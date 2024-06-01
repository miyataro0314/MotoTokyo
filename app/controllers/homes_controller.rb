class HomesController < ApplicationController
  before_action :require_profile, only: :my_page

  def home
    @spots = Spot.includes(:spot_detail).order(created_at: :desc).limit(5)
  end

  def my_page
    @profile = current_user.profile
  end

  def my_spots
    @selected_tab = params[:tab] || 'bookmark'
    @registered_spots = current_user.spots.order(created_at: :desc).page(params[:page_register])
    @bookmarked_spots = current_user.bookmarked_spots.order(created_at: :desc).page(params[:page_bookmark])
  end

  def account
    utc_time = current_user.created_at
    local_time = utc_time.in_time_zone(Rails.application.config.time_zone)
    @registration_date = local_time.strftime('%Y年%m月%d日')
  end

  def cancellation; end

  private

  def require_profile
    return if current_user.profile

    redirect_to new_profile_path, alert: 'プロフィールの登録をお願いします'
  end
end
