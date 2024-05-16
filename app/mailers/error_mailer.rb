class ErrorMailer < ApplicationMailer
  def registration_error(error_messages)
    @error_messages = error_messages
    mail(to: Rails.application.credentials.dig(:admin, :email), subject: 'スポット登録時エラー発生')
  end
end
