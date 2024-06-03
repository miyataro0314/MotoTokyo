class ApplicationController < ActionController::Base
  before_action :authenticate_user!

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
end
