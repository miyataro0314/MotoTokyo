class SpotsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]

  def new
    clear_session
  end

  def create
    @spot = build_spot

    save_spot

    if @spot.persisted?
      redirect_to success_spot_registrations_path(id: @spot.id)
    else
      redirect_to failure_spot_registrations_path
    end
  end

  def edit
    @spot = Spot.find(params[:id])
    @difficulty = Difficulty.find_by(user_id: current_user.id, spot_id: @spot.id)
    @comment = Comment.find_by(user_id: current_user.id, spot_id: @spot.id)
  end

  def show
    @spot = Spot.find(params[:id])
    @spot_detail = @spot.spot_detail
    @parkings = Parking.nearby(@spot_detail.coordinate, 1000)
    @comment = @spot.comments.order('RANDOM()').first

    save_access_history if user_signed_in?
  end

  def update
    @spot = Spot.find(params[:id])
    @difficulty = Difficulty.find_by(user_id: current_user.id, spot_id: @spot.id)
    @comment = Comment.find_or_initialize_by(user_id: current_user.id, spot_id: @spot.id)
    ActiveRecord::Base.transaction do
      if update_spot_and_diffculty && save_or_update_comment
        flash[:notice] = 'スポット情報を更新しました'
        redirect_to my_spots_path(tab: :register)
      else
        flash[:alert] = '更新に失敗しました'
        redirect_to my_spots_path(tab: :register)
        raise ActiveRecord::Rollback
      end
    end
  end

  def index
    @spots = Spot.all.includes(:spot_detail).order(created_at: :desc).page(params[:page])
  end

  def destroy
    @spot = Spot.find(params[:id])
    if @spot.destroy
      flash[:notice] = 'スポットを削除しました'
    else
      flash[:alert] = '削除に失敗しました'
    end
    redirect_to my_spots_path(tab: :register), status: :see_other
  end

  private

  def permitted_params
    params.require(:spot).permit(:name, :parking, :parking_limitation, :category,
                                 difficulty: :level, comment: :content)
  end

  def spot_params
    permitted_params.except(:difficulty, :comment)
  end

  def difficulty_params
    permitted_params[:difficulty]
  end

  def comment_params
    permitted_params[:comment]
  end

  def update_spot_and_diffculty
    @spot.update(spot_params) && @difficulty.update(difficulty_params)
  end

  def save_or_update_comment
    return true if comment_params.nil?

    if @comment.persisted?
      @comment.update(comment_params)
    else
      @comment.content = comment_params[:content]
      @comment.save
    end
  end

  def clear_session
    keys = %i[
      name parking parking_limitation difficulty_level category comment_content
      place_id postal_code street_address phone_number lat lng text
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
      parking: session[:parking],
      parking_limitation: session[:parking_limitation],
      category: session[:category],
      area:
    )
  end

  def build_spot_details(spot)
    factory = RGeo::Geographic.spherical_factory(srid: 4326)

    SpotDetail.new(
      id: session[:place_id],
      spot_id: spot.id,
      postal_code: session[:postal_code],
      street_address: session[:street_address],
      phone_number: session[:phone_number],
      coordinate: factory.point(session[:lng], session[:lat]),
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
      level: session[:difficulty_level]
    )
  end

  def build_comment(spot)
    Comment.new(
      user_id: current_user.id,
      spot_id: spot.id,
      content: session[:comment_content]
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
      @comment = build_comment(@spot)

      unless @spot_details.save && @difficulty.save && (@comment.content.present? ? @comment.save : true)
        handle_save_error
        raise ActiveRecord::Rollback
      end
    end
  end

  def handle_save_error
    @error_objects = [@spot, @spot_details, @difficulty, @comment].select { |object| object.errors.any? }
    ErrorMailer.registration_error(@error_objects).deliver_now
  end

  def save_access_history
    AccessHistory.create(user_id: current_user.id, spot_id: @spot.id)
  end
end
