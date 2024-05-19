class Admin::DashboardsController < Admin::BaseController
  before_action :authenticate_admin!
  def new
  end
end
