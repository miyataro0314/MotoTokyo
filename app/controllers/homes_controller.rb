class HomesController < ApplicationController
  before_action :authenticate_user!

  def home; end

  def my_page
    @profile = current_user.profile
  end

  def my_spots
    @selected_tab = params[:tab] || 'bookmark'
    @registered_spots = current_user.spots.page(params[:page_register]).order(:created_at)
    @bookmarked_spots = current_user.bookmarked_spots.page(params[:page_bookmark])
  end

  def account
    utc_time = current_user.created_at
    local_time = utc_time.in_time_zone(Rails.application.config.time_zone)
    @registration_date = local_time.strftime('%Y年%m月%d日')
  end
end
