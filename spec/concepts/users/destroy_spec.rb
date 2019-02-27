# frozen_string_literal: true

RSpec.describe Users::Operation::Destroy do
  subject(:result) { described_class.call(current_user: administrator, params: params) }

  let(:params) { { id: target_user_id } }
  let(:administrator) { create(:user, is_admin: is_admin) }
  let(:is_admin) { true }
  let(:target_user) { create(:user) }
  let(:target_user_id) { target_user.id }

  describe 'Success' do
    it 'removes user' do
      expect(result['result.policy.default']).to be_success
      expect(result[:model]).to eq(target_user)
      expect(result[:model]).to be_destroyed
      expect(result).to be_success
    end
  end

  describe 'Failure' do
    context 'when current_user is not an administrator' do
      let(:is_admin) { false }

      it 'breaches policy' do
        expect(result['result.policy.default']).to be_failure
        expect(result).to be_failure
      end
    end

    context 'with wrong id' do
      let(:params) { { id: 'wrong_id' } }

      it 'employee not found' do
        expect(result['result.model']).to be_failure
        expect(result).to be_failure
      end
    end

    context 'when tries to remove self' do
      let(:target_user_id) { administrator.id }
      let(:errors) do
        {
          base: ['Cannot remove self']
        }
      end

      it 'has validation errors' do
        expect(result[:errors]).to match errors
        expect(result).to be_failure
      end
    end
  end
end
