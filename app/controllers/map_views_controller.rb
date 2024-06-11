class MapViewsController < ApplicationController
  def new; end

  def spot_mini_card
    @spot = Spot.find(params[:id])
    render 'spots/spot_mini_card'
  end

  def parking_mini_card
    @parking = Parking.find(params[:id])
    render 'parkings/parking_mini_card'
  end
end
