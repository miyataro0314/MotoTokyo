class Admin::ParkingsController < ApplicationController
  def new
    clear_session
    @parking = Parking.new
  end

  def create
    @parking = build_parking
    save_parking
  end

  private

  def clear_session
    session.delete(:fee_field_index)
    session.delete(:capacity_field_index)
  end

  def parking_params
    params.require(:parking)
          .permit(:name, :postal_code, :street_address, :info, :fee, :capacity,
                  weekday_text: [
                    monday: %i[start end no_info],
                    tuesday: %i[start end no_info],
                    wednesday: %i[start end no_info],
                    thursday: %i[start end no_info],
                    friday: %i[start end no_info],
                    suturday: %i[start end no_info],
                    sunday: %i[start end no_info]
                  ])
  end

  def fee_params(attrs)
    ActionController::Parameters.new(attrs).permit(%i[description start_time end_time fee interval])
  end

  def capacity_params(attrs)
    ActionController::Parameters.new(attrs).permit(%i[capacity vehicle_type])
  end

  def build_parking
    area = Parking.areas.keys.find do |key|
      parking_params[:street_address].include?(I18n.t("activerecord.enums.parking.area.#{key}"))
    end

    weekday_text = build_weekday_text

    parking = Parking.new(parking_params)
    parking.area = area
    parking.weekday_text = weekday_text
    parking
  end

  def build_weekday_text
    weekdays = %w[月曜日 火曜日 水曜日 木曜日 金曜日 土曜日 日曜日]
    weekday_params = params[:parking][:weekday_text]

    weekday_params.to_unsafe_h.map.with_index do |(_, attrs), i|
      if attrs[:no_info] == '1'
        "#{weekdays[i]}: 営業時間情報なし"
      elsif attrs[:start] == '' && attrs[:end] == ''
        "#{weekdays[i]}: 24時間営業"
      else
        start_time = attrs[:start].gsub(/(\d+):(\d+)/, '\1時\2分')
        end_time = attrs[:end].gsub(/(\d+):(\d+)/, '\1時\2分')
        "#{weekdays[i]}: #{start_time}〜#{end_time}"
      end
    end
  end

  def save_parking
    ActiveRecord::Base.transaction do
      unless @parking.save
        flash[:alert] = @parking.errors.full_messages
        render 'admin/parking/new'
        raise ActiveRecord::Rollback
      end

      @fees = build_fees(@parking)
      @capacities = build_capacities(@parking)

      unless @fees.all?(&:save) && @capacities.all?(&:save)
        flash[:alert] = '料金・収容台数の保存時にエラーが発生しました'
        render 'admin/parking/new'
        raise ActiveRecord::Rollback
      end
    end

    flash[:info] = 'パーキングを登録しました'
    redirect_to new_admin_parking_path
  end

  def build_fees(parking)
    return nil unless params[:parking][:fee]

    fees_params = params[:parking][:fee]

    fees_params.to_unsafe_h.map do |_, attrs|
      permitted_params = fee_params(attrs)
      fee = ParkingFee.new(permitted_params)
      fee.parking = parking
      fee
    end
  end

  def build_capacities(parking)
    return nil unless params[:parking][:capacity]

    capacities_params = params[:parking][:capacity]

    capacities_params.to_unsafe_h.map do |_, attrs|
      permitted_params = capacity_params(attrs)
      capacity = ParkingCapacity.new(permitted_params)
      capacity.parking = parking
      capacity
    end
  end
end
