class ParkingFee < ApplicationRecord
  belongs_to :parking

  enum interval: {
    day: 0,
    six_hours: 5,
    three_hours: 10,
    two_hours: 15,
    hour: 20,
    half_hour: 25,
    twenty_minues: 30,
    ten_minuets: 35
  }
end
