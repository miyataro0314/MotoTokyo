class Admin::SessionsController < Devise::SessionsController
  def new
    self.resource = resource_class.new(sign_in_params)
    clean_up_passwords(resource)
    yield resource if block_given?
    respond_with(resource, serialize_options(resource))
  end

  def create
    self.resource = warden.authenticate!(auth_options)
    return unless admin_authenticate

    set_flash_message!(:notice, :signed_in)
    sign_in(resource_name, resource)
    yield resource if block_given?
    redirect_to admin_root_path
  end

  def destroy
    admin_sign_out
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    set_flash_message! :notice, :signed_out if signed_out
    yield if block_given?
    respond_to_on_destroy
  end

  private

  def admin_authenticate
    if resource.admin? && admin_password_valid?
      session[:as_admin] = true
      true
    else
      flash[:alert] = 'Invalid admin authenticate.'
      redirect_to root_path
      false
    end
  end

  def admin_password_valid?
    params[:user][:admin_password] == Rails.application.credentials.admin[:password]
  end

  def admin_sign_out
    session.delete(:as_admin)
  end
end
