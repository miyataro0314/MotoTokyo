class Parking < ApplicationRecord
  geocoded_by :street_address
  after_validation :set_geolocation, if: :street_address_changed?

  include AreaEnum

  has_many :parking_fees, dependent: :destroy
  has_many :parking_capacities, dependent: :destroy

  accepts_nested_attributes_for :parking_fees
  accepts_nested_attributes_for :parking_capacities

  def set_geolocation
    return unless geocoded = Geocoder.search(street_address).first

    factory = RGeo::Geographic.spherical_factory(srid: 4326)
    self.coordinate = factory.point(geocoded.longitude, geocoded.latitude)
  end
end
