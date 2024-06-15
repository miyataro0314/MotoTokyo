class ProfilesController < ApplicationController
  def new
    @profile = Profile.new
  end

  def edit
    @profile = current_user.profile
  end

  def create
    @profile = Profile.new(profile_params)
    @profile.user_id = current_user.id
    if @profile.save
      @profile.convert_images
      flash[:notice] = I18n.t('flash.profiles.create.notice')
      redirect_to my_page_path
    else
      flash.now[:alert] = I18n.t('flash.profiles.create.alert')
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @profile = current_user.profile
    if @profile.update(profile_params)
      @profile.convert_images
      flash[:notice] = I18n.t('flash.profiles.update.notice')
      redirect_to my_page_path
    else
      flash.now[:alert] = I18n.t('flash.profiles.create.alert')
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def profile_params
    params.require(:profile).permit(%i[user_name avatar vehicle_name vehicle_type vehicle_photo])
  end
end
