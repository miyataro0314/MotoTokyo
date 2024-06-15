class SpotsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]

  def index
    @spots = Spot.includes(:spot_detail).order(created_at: :desc).page(params[:page])
  end

  def show
    @spot = Spot.find(params[:id])
    @spot_detail = @spot.spot_detail
    @parkings = Parking.nearby(@spot_detail.coordinate, 1000)
    @comment = @spot.comments.order('RANDOM()').first

    save_access_history if user_signed_in?
  end

  def new
    clear_session
  end

  def edit
    prepare_spot_and_spot_form
  end

  def create
    @spot = build_spot

    spot_saver = SpotSaver.new(session:, spot: @spot, user: current_user)

    if spot_saver.save
      redirect_to success_spot_registrations_path(id: @spot.id)
    else
      redirect_to failure_spot_registrations_path
    end
  end

  def update
    prepare_spot_and_spot_form

    if @spot_form.update(params)
      flash[:notice] = I18n.t('flash.spots.update.notice')
    else
      flash[:alert] = I18n.t('flash.spots.update.alert')
    end
    redirect_to my_spots_path(tab: :register)
  end

  def destroy
    @spot = Spot.find(params[:id])
    if @spot.destroy
      flash[:notice] = I18n.t('flash.spots.destroy.notice')
    else
      flash[:alert] = I18n.t('flash.spots.destroy.alert')
    end
    redirect_to my_spots_path(tab: :register), status: :see_other
  end

  private

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

  def save_access_history
    AccessHistory.create(user_id: current_user.id, spot_id: @spot.id)
  end

  def prepare_spot_and_spot_form
    @spot = Spot.find(params[:id])
    @spot_form = SpotForm.new(
      spot: @spot,
      difficulty: Difficulty.find_by(user_id: current_user.id, spot_id: @spot.id),
      comment: Comment.find_or_initialize_by(user_id: current_user.id, spot_id: @spot.id)
    )
  end
end
