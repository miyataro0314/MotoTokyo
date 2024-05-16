class SpotsController < ApplicationController
  def new
    clear_session
  end

  def create
    @spot = build_spot

    save_spot

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

  def save_spot
    ActiveRecord::Base.transaction do
      unless @spot.save
        handle_save_error
        raise ActiveRecord::Rollback
      end

      @spot_details = build_spot_details(@spot)
      @difficulty = build_difficulty(@spot)

      unless @spot_details.save && @difficulty.save
        handle_save_error
        raise ActiveRecord::Rollback
      end
    end
  end

  def handle_save_error
    @error_objects = [@spot, @spot_details, @difficulty].select { |object| object.errors.any? }
    ErrorMailer.registration_error(@error_objects).deliver_now
  end
end
