module ParkingEnum
  extend ActiveSupport::Concern

  included do
    enum parking: { free: 0, paid: 5, nothing: 10, unknown: 15 }
  end
end
