module SpotsHelper
  def spot_parking_info(spot)
    return '無し' if spot.parking == 'nothing'

    localed_parking = t_enum('spot', 'parking', spot.parking)
    localed_parking_limitation = t_enum('spot', 'parking_limitation', spot.parking_limitation)
    "#{localed_parking} : #{localed_parking_limitation}"
  end
end
