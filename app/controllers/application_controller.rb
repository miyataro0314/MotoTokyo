class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :check_unread_notifications, if: :user_signed_in?

  def tweet(message)
    json = { text: message }.to_json

    x_credentials = {
      api_key: Rails.application.credentials.x[:api_key],
      api_key_secret: Rails.application.credentials.x[:api_key_secret],
      access_token: Rails.application.credentials.x[:access_token],
      access_token_secret: Rails.application.credentials.x[:access_token_secret]
    }

    x_client = X::Client.new(**x_credentials)
    x_client.post('tweets', json)
  end

  private

  def check_unread_notifications
    @notification_icon_path = if current_user.notifications.unread.any?
                                'vuesax/linear/unread_notification.svg'
                              else
                                'vuesax/linear/notification.svg'
                              end
  end
end
