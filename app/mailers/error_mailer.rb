class ErrorMailer < ApplicationMailer
  def registration_error(error_objects)
    @error_objects = error_objects
    mail(to: Rails.application.credentials.admin[:email], subject: I18n.t('mailers.registration_error.subject'))
  end
end
