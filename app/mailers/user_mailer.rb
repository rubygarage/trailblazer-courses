# frozen_string_literal: true

class UserMailer < ApplicationMailer
  default site: 'example.stub'

  def reset_password(user, token)
    @user = user
    @link = token_link(token)
    mail(to: @user.email,
         subject: I18n.t('user_mailer.reset_password.subject'))
  end

  private

  def token_link(token)
    URI.parse("#{Rails.application.config.client_url}/reset_password?token=#{token}").to_s
  end
end
