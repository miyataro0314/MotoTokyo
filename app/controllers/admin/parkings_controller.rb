class Admin::ParkingsController < ApplicationController
  def index
    @parkings = Parking.all.order(:updated_at)
  end

  def edit
    @parking = Parking.find(params[:id])
  end

  def update
    @parking = Parking.find(params[:id])
    if @parking.update(parking_params)
      redirect_to admin_parkings_path, info: '更新しました'
    else
      flash.now[:alert] = @parking.error.full_messages
      render :edit
    end
  end

  private

  def parking_params
    params.require(:parking)
          .permit(%i[name postal_code address fee closed_days opening_hours capacity limitation url])
  end
end
