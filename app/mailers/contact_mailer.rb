class ContactMailer < ApplicationMailer
  def mail_to_user(contact_form)
    @contact_form = contact_form
    mail(to: @contact_form.email, subject: 'お問い合わせ内容の確認')
  end

  def mail_to_admin(contact_form)
    @contact_form = contact_form
    mail(to: Rails.application.credentials.admin[:email], subject: 'お問い合わせ')
  end
end
