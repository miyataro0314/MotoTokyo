class SpotsController < ApplicationController
  def new
    clear_session
  end

  def create
    @spot = build_spot
    spot_details = build_spot_details(@spot)
    difficulty = build_difficulty(@spot)

    save_spot(@spot, spot_details, difficulty)

    if @spot.persisted?
      @count = Spot.all.count
      render 'spot_registrations/success'
    else
      render 'spot_registrations/failure'
    end
  end

  private

  def clear_session
    keys = %i[
      name parking parking_limitation difficulty_level category comment_content
      place_id postal_code region street_address phone_number lat lng text
      rating user_rating_total url
    ]
    keys.each { |key| session.delete(key) }
  end

  def build_spot
    address = session[:street_address]
    area = Spot.areas.keys.find do |key|
      address.include?(I18n.t("activerecord.enums.spot.area.#{key}"))
    end

    Spot.new(
      user_id: current_user.id,
      name: session[:name],
      parking: Spot.parkings[session[:parking]],
      parking_limitation: Spot.parking_limitations[session[:parking_limitation]],
      category: Spot.categories[session[:category]],
      area: area
    )
  end

  def build_spot_details(spot)
    SpotDetail.new(
      id: session[:place_id],
      spot_id: spot.id,
      postal_code: session[:postal_code],
      region: session[:region],
      street_address: session[:street_address],
      phone_number: session[:phone_number],
      coordinate: "POINT(#{session[:lat]} #{session[:lng]})",
      weekday_text: session[:weekday_text],
      rating: session[:rating],
      user_rating_total: session[:user_rating_total],
      url: session[:url]
    )
  end

  def build_difficulty(spot)
    Difficulty.new(
      user_id: current_user.id,
      spot_id: spot.id,
      level: Difficulty.levels[session[:difficulty_level]]
    )
  end

  def save_spot(spot, spot_details, difficulty)
    ActiveRecord::Base.transaction do
      unless spot.save && spot_details.save && difficulty.save
        flash[:error] = '登録に失敗しました'
        mail_error_message([@spot, spot_details, difficulty])
        raise ActiveRecord::Rollback
      end
    end
  end

  def mail_error_message(objects)
    @error_objects = []
    objects.each { |object| @error_objects << object if object.errors }
    ErrorMailer.registration_error(@error_objects).deliver_now
  end
end
