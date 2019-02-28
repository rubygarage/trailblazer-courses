# frozen_string_literal: true

RSpec.describe ResetPasswords::Operation::Update do
  subject(:result) { described_class.call(params: params) }

  let(:token) { Service::JWTAdapter.encode(aud: 'reset_password', sub: user.id, exp: 1.day.from_now.to_i) }
  let(:user) { create(:user) }

  describe 'Success' do
    let(:params) { { token: token, password: 'Password1', password_confirmation: 'Password1' } }

    it "updates employee's password with new one" do
      expect(Service::JWTAdapter).to receive(:decode).with(
        token,
        aud: 'reset_password',
        verify_aud: true
      ).and_call_original

      expect { result }.to(change { user.reload.password_digest })
      expect(result[:model]).to eq(user)
      expect(result).to be_success
    end
  end

  describe 'Failure' do
    context 'when token is invalid' do
      let(:params) { { token: 'invalid_token', password: 'Password1', password_confirmation: 'Password1' } }
      let(:errors) { { token: 'is in invalid_format' } }

      it 'sets failure_semantic to :gone' do
        expect(result[:failure_semantic]).to eq(:gone)
        expect(result).to be_failure
      end
    end

    context "when password doesn't match regex" do
      let(:params) { { token: token, password: '11111111', password_confirmation: '11111111' } }
      let(:errors) { { password: ['is in invalid format', 'size cannot be less than 8'] } }

      it 'has validation errors' do
        expect(result['result.contract.default'].errors.messages).to match errors
        expect(result).to be_failure
      end
    end

    context 'when password length not corresponds requirements' do
      let(:params) { { token: token, password: '1', password_confirmation: '1' } }
      let(:errors) { { password: ['is in invalid format', 'size cannot be less than 8'] } }

      it 'has validation errors' do
        expect(result['result.contract.default'].errors.messages).to match errors
        expect(result).to be_failure
      end
    end

    context 'when password_confirmation is not equals password' do
      let(:params) { { token: token, password: 'Password1', password_confirmation: 'Password2' } }
      let(:errors) { { password_confirmation: ['must match password'] } }

      it 'has validation errors' do
        expect(result['result.contract.default'].errors.messages).to match errors
        expect(result).to be_failure
      end
    end

    context 'when token has no user id in payload' do
      let(:token) { Service::JWTAdapter.encode(aud: 'reset_password', exp: 1.day.from_now.to_i) }
      let(:params) { { token: token, password: 'Password1', password_confirmation: 'Password1' } }

      it 'fails result' do
        expect(result[:failure_semantic]).to eq(:gone)
        expect(result).to be_failure
      end
    end

    context 'when token has non existent employee_account_id in payload' do
      let(:token) { Service::JWTAdapter.encode(aud: 'reset_password', sub: User.ids.sum + 1, exp: 1.day.from_now.to_i) }
      let(:params) { { token: token, password: 'Password1', password_confirmation: 'Password1' } }

      it 'fails result' do
        expect(result[:failure_semantic]).to eq(:gone)
        expect(result).to be_failure
      end
    end
  end
end
