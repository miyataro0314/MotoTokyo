class StaticPagesController < ApplicationController
  skip_before_action :authenticate_user!, except: %i[contact send_contact]

  def top; end

  def about; end

  def terms; end

  def privacy_policy; end

  def side_menu; end

  def contact
    @contact_form = ContactForm.new(
      user_id: current_user.id,
      email: current_user.email
    )
  end

  def send_contact
    @contact_form = ContactForm.new(contact_params)

    begin
      ContactMailer.mail_to_user(@contact_form).deliver_now
      ContactMailer.mail_to_admin(@contact_form).deliver_now

      redirect_to home_path, notice: I18n.t('お問い合わせを送信しました。5~10分以内に確認メールが送信されます。')
    rescue => e
      logger.error "お問い合わせの送信に失敗しました: #{e.message}"
      flash.now[:alert] = I18n.t('お問い合わせの送信に失敗しました。恐れ入りますが再度お試しください。')
      render :contact
    end
  end

  private

  def contact_params
    params.require(:contact_form).permit(%i[user_id email content])
  end
end
