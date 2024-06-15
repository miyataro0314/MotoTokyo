class ContactMailer < ApplicationMailer
  def mail_to_user(contact_form)
    @contact_form = contact_form
    mail(to: @contact_form.email, subject: I18n.t('mailers.contact.mail_to_user.subject'))
  end

  def mail_to_admin(contact_form)
    @contact_form = contact_form
    mail(to: Rails.application.credentials.admin[:email], subject: I18n.t('mailers.contact.mail_to_admin.subject'))
  end
end
