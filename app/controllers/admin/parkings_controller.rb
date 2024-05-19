class Admin::ParkingsController < ApplicationController
  def new
    @parking = Parking.new
  end

  def create
    build_parking
    save_parking
  end

  private

  def parking_params
    params.require(:parking).permit(%i[name postal_code street_address weekday_text])
  end

  def build_parking
    area = Parking.areas.keys.find do |key|
      parking_params[:street_address].include?(I18n.t("activerecord.enums.parking.area.#{key}"))
    end

    @parking = Parking.new(parking_params)
    @parking.area = area
  end

  def save_parking
    ActiveRecord::Base.transaction do
      unless @parking.save
        flash[:alert] = @parking.errors.full_messages
        render 'admin/new'
        raise ActiveRecord::Rollback
      end
      # @spot_details = build_spot_details(@spot)
      # @difficulty = build_difficulty(@spot)

      # raise ActiveRecord::Rollback if @spot_details.save && @difficulty.save
    end
  end
end
