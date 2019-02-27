# frozen_string_literal: true

RSpec.describe 'Users', :dox, type: :request do
  include ApiDoc::Users::Api

  describe 'GET #index' do
    include ApiDoc::Users::Index

    let(:params) { { page: page } }
    let(:headers) { { Authorization: "{ \"user_id\": #{current_user.id} }" } }
    let(:current_user) { create(:user, is_admin: is_admin) }
    let(:is_admin) { true }
    let(:page) { 2 }

    before do
      create_list(:user, 7)
      stub_const('Pagy::VARS', Pagy::VARS.merge(items: 2))
      get '/users', params: params, headers: headers
    end

    describe 'Success' do
      it 'renders paginated list of users' do
        expect(JSON.parse(response.body)['data'][0]['type']).to eq('users')
        expect(response).to be_ok
        expect(response).to match_json_schema('users/index')
      end
    end

    describe 'Failure' do
      context 'when authorization headers is not valid' do
        let(:headers) { {} }

        it 'renders errors' do
          expect(response).to be_unauthorized
          expect(response).to match_json_schema('errors')
        end
      end

      context 'when current_user is not an administrator' do
        let(:is_admin) { false }

        it 'returns forbidden status' do
          expect(response).to be_forbidden
          expect(response.body).to be_empty
        end
      end

      context 'when page is not valid' do
        let(:page) { 'wrong' }

        it 'renders errors' do
          expect(response).to be_unprocessable
          expect(response).to match_json_schema('errors')
        end
      end

      context 'when page is out of limits' do
        let(:page) { 9999 }

        it 'renders errors' do
          expect(response).to be_unprocessable
          expect(response).to match_json_schema('errors')
        end
      end
    end
  end

  describe 'GET #destroy' do
    include ApiDoc::Users::Index

    let(:headers) { { Authorization: "{ \"user_id\": #{current_user.id} }" } }
    let(:current_user) { create(:user, is_admin: is_admin) }
    let(:is_admin) { true }
    let(:target_user) { create(:user) }
    let(:target_user_id) { target_user.id }

    before do
      delete "/users/#{target_user_id}", headers: headers
    end

    describe 'Success' do
      it 'renders paginated list of users' do
        expect(response).to be_no_content
        expect(response.body).to be_empty
      end
    end

    describe 'Failure' do
      context 'when authorization headers is not valid' do
        let(:headers) { {} }

        it 'renders errors' do
          expect(response).to be_unauthorized
          expect(response).to match_json_schema('errors')
        end
      end

      context 'when current_user is not an administrator' do
        let(:is_admin) { false }

        it 'returns forbidden status' do
          expect(response).to be_forbidden
          expect(response.body).to be_empty
        end
      end

      context 'when triyng remove self' do
        let(:target_user_id) { current_user.id }

        it 'renders errors' do
          expect(response).to be_unprocessable
          expect(response).to match_json_schema('errors')
        end
      end
    end
  end
end
