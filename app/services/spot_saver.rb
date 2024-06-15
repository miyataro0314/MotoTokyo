class SpotSaver
  def initialize(session:, spot:, user:)
    @session = session
    @spot = spot
    @user = user
  end

  def save
    save_spot
  end

  private

  def save_spot
    ActiveRecord::Base.transaction do
      unless @spot.save
        handle_save_error
        raise ActiveRecord::Rollback
      end

      build_association_objects

      unless @spot_detail.save && @difficulty.save && (@comment.content.present? ? @comment.save : true)
        handle_save_error
        raise ActiveRecord::Rollback
      end
    end
    true
  rescue ActiveRecord::Rollback
    false
  end

  def build_association_objects
    @spot_detail = build_spot_detail
    @difficulty = build_difficulty
    @comment = build_comment
  end

  def build_spot_detail
    SpotDetail.new(
      id: @session[:place_id],
      spot_id: @spot.id,
      postal_code: @session[:postal_code],
      street_address: @session[:street_address],
      phone_number: @session[:phone_number],
      coordinate: build_coordinate,
      weekday_text: @session[:weekday_text],
      rating: @session[:rating],
      user_rating_total: @session[:user_rating_total],
      url: @session[:url]
    )
  end

  def build_coordinate
    factory = RGeo::Geographic.spherical_factory(srid: 4326)
    factory.point(@session[:lng], @session[:lat])
  end

  def build_difficulty
    Difficulty.new(
      user_id: @user.id,
      spot_id: @spot.id,
      level: @session[:difficulty_level]
    )
  end

  def build_comment
    Comment.new(
      user_id: @user.id,
      spot_id: @spot.id,
      content: @session[:comment_content]
    )
  end

  def handle_save_error
    @error_objects = [@spot, @spot_details, @difficulty, @comment].select { |object| object.errors.any? }
    ErrorMailer.registration_error(@error_objects).deliver_now
  end
end
