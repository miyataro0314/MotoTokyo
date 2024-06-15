module Admin
  class BaseController < ApplicationController
    def authenticate_admin!
      return unless authenticate_user!

      return if current_user.admin? && session[:as_admin] == true

      flash[:alert] = I18n.t('flash.admin.base.authenticate_admin.alert')
      redirect_to root_path
    end
  end
end
