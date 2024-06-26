# frozen_string_literal: true

class Users::PasswordsController < Devise::PasswordsController
  skip_before_action :require_no_authentication

  # GET /resource/password/new
  def new
    super
  end

  # GET /resource/password/edit?reset_password_token=abcdef
  def edit
    super
  end

  # POST /resource/password
  def create
    super
  end

  # PUT /resource/password
  def update
    super
  end

  # protected

  # def after_resetting_password_path_for(resource)
  #   super(resource)
  # end

  # The path used after sending reset password instructions
  def after_sending_reset_password_instructions_path_for(_)
    if user_signed_in?
      home_path
    else
      root_path
    end
  end
end
