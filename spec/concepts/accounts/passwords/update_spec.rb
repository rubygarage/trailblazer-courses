# frozen_string_literal: true

RSpec.describe Accounts::Passwords::Operation::Update do
  subject(:result) { described_class.call(params: params, current_user: current_user) }

  let(:params) { {} }

  let(:old_password) { 'Password1!' }
  let(:current_user) { create(:user, password: old_password) }

  describe 'Success' do
    let(:params) { { old_password: old_password, password: 'Password2@', password_confirmation: 'Password2@' } }

    it 'changes employee password' do
      expect { result }.to(change(current_user, :password_digest))
      expect(result[:auth]).to eq({ user_id: current_user.id }.to_json)
      expect(result).to be_success
    end
  end

  describe 'Failure' do
    context 'with empty keys' do
      let(:errors) do
        {
          old_password: ['must be filled'],
          password: ['must be filled', 'size cannot be less than 8']
        }
      end

      it 'has validation errors' do
        expect(result['result.contract.default'].errors.messages).to match errors
        expect(result).to be_failure
      end
    end

    context 'without confirmation' do
      let(:params) { { old_password: old_password, password: 'Password2@' } }
      let(:errors) { { password_confirmation: ['must match password'] } }

      it 'has validation errors' do
        expect(result['result.contract.default'].errors.messages).to match errors
        expect(result).to be_failure
      end
    end

    context 'when confirmation does not match' do
      let(:params) { { old_password: old_password, password: 'Password2@', password_confirmation: 'Wrong' } }
      let(:errors) { { password_confirmation: ['must match password'] } }

      it 'has validation errors' do
        expect(result['result.contract.default'].errors.messages).to match errors
        expect(result).to be_failure
      end
    end

    context 'when password does not match regex' do
      let(:params) { { old_password: old_password, password: 'password', password_confirmation: 'password' } }
      let(:errors) { { password: ['is in invalid format'] } }

      it 'has validation errors' do
        expect(result['result.contract.default'].errors.messages).to match errors
        expect(result).to be_failure
      end
    end

    context 'when password is too short' do
      let(:params) { { old_password: old_password, password: 'P2@', password_confirmation: 'P2@' } }
      let(:errors) { { password: ['size cannot be less than 8'] } }

      it 'has validation errors' do
        expect(result['result.contract.default'].errors.messages).to match errors
        expect(result).to be_failure
      end
    end

    context 'when old password is wrong' do
      let(:params) { { old_password: 'wrong', password: 'Password2@', password_confirmation: 'Password2@' } }
      let(:errors) { { base: ['Wrong password'] } }

      it 'has validation errors' do
        expect(result['result.contract.default'].errors.messages).to match errors
        expect(result).to be_failure
      end
    end
  end
end
