module Admin
  class BaseController < ApplicationController
    def authenticate_admin!
      return unless authenticate_user!

      return if current_user.admin? && session[:as_admin] == true

      flash[:alert] = 'Invalid admin authenticate.'
      redirect_to root_path
    end
  end
end
