# frozen_string_literal: true

RSpec.describe ResetPasswords::Operation::Show do
  subject(:result) { described_class.call(params: params) }

  let(:token) { Service::JWTAdapter.encode(aud: 'reset_password', sub: user.id, exp: 1.day.from_now.to_i) }
  let(:user) { create(:user) }
  let(:params) { { token: token } }

  describe 'Success' do
    it 'checks validity of token' do
      expect(Service::JWTAdapter).to receive(:decode).with(
        token,
        aud: 'reset_password',
        verify_aud: true
      ).and_call_original

      expect(result).to be_success
    end
  end

  describe 'Failure' do
    context 'when token is expired' do
      let(:token) { Service::JWTAdapter.encode(aud: 'reset_password', sub: user.id, exp: -1.day.from_now.to_i) }

      it 'disallows token as invalid' do
        expect(result[:failure_semantic]).to eq(:gone)
        expect(result['result.contract.default']).to be_success
        expect(result).to be_failure
      end
    end

    context 'when token is not valid or there are no token at all' do
      let(:token) { '' }
      let(:errors) { { token: ['must be filled'] } }

      it 'has validation errors' do
        expect(result[:failure_semantic]).to eq(:gone)
        expect(result['result.contract.default'].errors.messages).to match errors
        expect(result).to be_failure
      end
    end
  end
end
