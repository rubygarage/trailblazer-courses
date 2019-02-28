# frozen_string_literal: true

RSpec.describe UserMailer, type: :mailer do
  let(:user) { create(:user) }

  shared_examples 'mail with correct headers' do
    it 'renders the headers' do
      expect(mail.subject).to eq(mail_subject)
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['no-reply@example.com'])
    end
  end

  describe '.reset_password' do
    let(:mail) do
      described_class.reset_password(user, token)
    end

    let(:token) { Service::JWTAdapter.encode(aud: 'reset_password', sub: user.id, exp: 1.day.from_now.to_i) }
    let(:link) { "#{Rails.application.config.client_url}/reset_password?token=#{token}" }

    it_behaves_like 'mail with correct headers' do
      let(:mail_subject) { I18n.t('user_mailer.reset_password.subject') }
    end

    it 'renders the body with restore password link' do
      expect(mail.body.encoded).to include(link)
    end
  end
end
