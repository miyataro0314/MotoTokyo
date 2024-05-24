class ParkingCapacity < ApplicationRecord
  belongs_to :parking

  enum vehicle_type: { all_ok: 0, no_big: 5, only_scooter: 10 }
end
