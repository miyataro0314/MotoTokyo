class ParkingsController < ApplicationController
  skip_before_action :authenticate_user!

  def show
    @parking = Parking.find(params[:id])
    @fees = ParkingFee.where(parking_id: params[:id])
    @capacities = ParkingCapacity.where(parking_id: params[:id])
  end
end
