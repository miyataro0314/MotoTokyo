class Parking < ApplicationRecord
  geocoded_by :street_address
  after_validation :set_geolocation, if: :street_address_changed?

  include AreaEnum

  has_many :parking_fees, dependent: :destroy
  has_many :parking_capacities, dependent: :destroy

  accepts_nested_attributes_for :parking_fees
  accepts_nested_attributes_for :parking_capacities

  scope :nearby, lambda { |point, distance|
    where('ST_DWithin(coordinate, ST_GeomFromText(?, 4326), ?)', point.to_s, distance)
      .order(Arel.sql('ST_Distance(coordinate, ST_GeomFromText(?, 4326))', point.to_s))
  }

  def address
    "東京都#{street_address}"
  end

  def opening_hours
    return if weekday_text.nil?

    op_hours = weekday_text[(Time.zone.today.wday + 6) % 7]
    op_hours&.slice!(5..) || '営業時間：情報なし'
  end

  def distance(st_point)
    self.class.connection.execute(
      "SELECT ST_DistanceSphere(
        ST_GeomFromText('POINT(#{coordinate.longitude} #{coordinate.latitude})', 4326),
        ST_GeomFromText('POINT(#{st_point.longitude} #{st_point.latitude})', 4326)
      ) AS distance"
    ).first['distance'].round
  end

  def set_geolocation
    return unless geocoded = Geocoder.search(street_address).first

    factory = RGeo::Geographic.spherical_factory(srid: 4326)
    self.coordinate = factory.point(geocoded.longitude, geocoded.latitude)
  end
end
