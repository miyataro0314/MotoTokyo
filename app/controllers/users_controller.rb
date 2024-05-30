class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])

    if @user == current_user
      redirect_to my_page_path
      return
    end

    @profile = @user.profile
    return if @profile

    redirect_to spot_path(params[:spot_id]), alert: 'このユーザーはプロフィール未設定です'
  end
end
