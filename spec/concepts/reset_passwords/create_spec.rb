# frozen_string_literal: true

RSpec.describe ResetPasswords::Operation::Create do
  subject(:result) { described_class.call(params: params) }

  let(:token) { 'token' }
  let(:user) { create(:user) }
  let(:params) { { email: user.email } }

  describe 'Success' do
    context 'when user exists' do
      it 'creates restore password link' do
        expect(Lib::Service::TokenCreator::ResetPassword).to(
          receive(:call).with(user).and_return(token)
        )
        expect(UserMailer).to receive_message_chain(
          :reset_password, :deliver_later
        ).with(user.id, token).with(no_args).and_return(true)
        expect(result[:model]).to eq(user)
        expect(result[:success_semantic]).to eq(:created)
        expect(result).to be_success
      end
    end

    context 'when email is not registered' do
      let(:params) { { email: 'not@exist.com' } }

      it 'silently succeeds' do
        expect(Lib::Service::TokenCreator::ResetPassword).not_to receive(:call)
        expect(UserMailer).not_to receive(:reset_password)
        expect(result['result.model']).to be_failure
        expect(result[:model]).to eq(nil)
        expect(result[:success_semantic]).to eq(:created)

        expect(result).to be_success
      end
    end
  end

  describe 'Failure' do
    context 'when empty params' do
      let(:params) { {} }
      let(:errors) { { email: ['must be filled'] } }

      it 'has validation errors' do
        expect(result['result.contract.default'].errors.messages).to match errors
        expect(result).to be_failure
      end
    end

    context "when email doesn't match regex" do
      let(:params) { { email: 'wrong_email' } }
      let(:errors) { { email: ['is in invalid format'] } }

      it 'has validation errors' do
        expect(result['result.contract.default'].errors.messages).to match errors
        expect(result).to be_failure
      end
    end
  end
end
