class ParkingsController < ApplicationController
  skip_before_action :authenticate_user!

  def show
    @parking = Parking.find(params[:id])
  end
end
