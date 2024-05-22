class HomesController < ApplicationController
  before_action :authenticate_user!

  def home; end

  def my_page
    @profile = current_user.profile
  end

  def my_spots
    @selected_tab = params[:tab] || 'bookmark'
    @registered_spots = current_user.spots.page(params[:page_register])
    @bookmarked_spots = current_user.bookmarked_spots.page(params[:page_bookmark])
  end
end
