# frozen_string_literal: true

RSpec.describe 'Account::Password', :dox, type: :request do
  include ApiDoc::Account::Password::Api

  describe 'PUT #update' do
    include ApiDoc::Account::Password::Update

    let(:old_password) { 'Password1!' }
    let(:user) { create(:user, password: old_password) }
    let(:headers) { { Authorization: "{ \"user_id\": #{user.id} }" } }
    let(:params) { { old_password: old_password, password: 'Password2@', password_confirmation: 'Password2@' } }

    before do
      put '/account/password', params: params, headers: headers, as: :json
    end

    describe 'Success' do
      it 'updates employee role' do
        expect(response).to be_ok
        expect(response.body).to match_json_schema('account/password/update')
      end
    end

    describe 'Fail' do
      context 'when authorization headers is not valid' do
        let(:headers) { {} }

        it 'renders errors' do
          expect(response).to be_unauthorized
          expect(response).to match_json_schema('errors')
        end
      end

      context 'when params is empty' do
        let(:params) { {} }

        it 'renders errors' do
          expect(response).to be_unprocessable
          expect(response.body).to match_json_schema('errors')
        end
      end

      context 'when confirmation does not match' do
        let(:params) { { old_password: old_password, password: 'Password2@', password_confirmation: 'not match' } }

        it 'renders errors' do
          expect(response).to be_unprocessable
          expect(response.body).to match_json_schema('errors')
        end
      end

      context 'when current password is incorrect' do
        let(:params) { { old_password: 'incorrect', password: 'Password2@', password_confirmation: 'not match' } }

        it 'renders errors' do
          expect(response).to be_unprocessable
          expect(response.body).to match_json_schema('errors')
        end
      end
    end
  end
end
