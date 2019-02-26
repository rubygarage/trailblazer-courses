# frozen_string_literal: true

RSpec.describe Users::Operation::Index do
  subject(:result) { described_class.call(current_user: administrator, params: params) }

  let(:params) { { page: page } }
  let(:administrator) { create(:user, is_admin: is_admin) }
  let(:is_admin) { true }
  let(:page) { 2 }

  describe 'Success' do
    before do
      stub_const('Pagy::VARS', Pagy::VARS.merge(items: 2))
      create_list(:user, 7)
    end

    it 'returns paginated list of employees' do
      expect(result['result.policy.default']).to be_success
      expect(result[:model]).to be_a(ActiveRecord::Relation)
      expect(result[:model].sample).to be_a(User)
      expect(result[:model].length).to be(2)
      expect(result[:pagy]).to be_instance_of(Pagy)
      expect(result[:renderer_options][:links]).to eq(self: '/users?page=2',
                                                      first: '/users',
                                                      next: '/users?page=3',
                                                      prev: '/users?page=1',
                                                      last: '/users?page=4')
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

    context 'when page is not valid' do
      let(:page) { 'wrong' }
      let(:errors) do
        {
          page: ['must be an integer', 'must be greater than or equal to 1']
        }
      end

      it 'has validation errors' do
        expect(result['contract.default'].errors.messages).to match errors
        expect(result).to be_failure
      end
    end

    context 'when page is out of limits' do
      let(:page) { 9999 }
      let(:errors) do
        {
          page: ['is out of limits']
        }
      end

      it 'has validation errors' do
        expect(result['contract.default'].errors.messages).to match errors
        expect(result).to be_failure
      end
    end
  end
end
