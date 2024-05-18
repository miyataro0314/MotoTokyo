class ErrorMailer < ApplicationMailer
  def registration_error(error_objects)
    @error_objects = error_objects
    mail(to: Rails.application.credentials.admin[:email], subject: 'スポット登録時エラー発生')
  end
end
