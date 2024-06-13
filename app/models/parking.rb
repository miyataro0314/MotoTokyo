class Parking < ApplicationRecord
  include AreaEnum

  before_validation :set_area, if: :address_changed?

  validates :name, presence: true
  validates :area, presence: true
  validates :address, presence: true

  scope :nearby, lambda { |point, distance|
    where('ST_DWithin(coordinate, ST_GeomFromText(?, 4326), ?)', point.to_s, distance)
      .order(Arel.sql('ST_Distance(coordinate, ST_GeomFromText(?, 4326))', point.to_s))
  }

  def operation_info
    opening_hours || '営業時間情報無し'
  end

  def distance(st_point)
    self.class.connection.execute(
      "SELECT ST_DistanceSphere(
        ST_GeomFromText('POINT(#{coordinate.longitude} #{coordinate.latitude})', 4326),
        ST_GeomFromText('POINT(#{st_point.longitude} #{st_point.latitude})', 4326)
      ) AS distance"
    ).first['distance'].round
  end

  private

  def set_area
    self.area = Parking.areas.keys.find do |key|
      address.include?(I18n.t("activerecord.enums.parking.area.#{key}"))
    end
  end
end
