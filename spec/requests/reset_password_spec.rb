# frozen_string_literal: true

RSpec.describe 'ResetPasswords', type: :request do
  include ApiDoc::ResetPassword::Api

  describe 'GET #show' do
    include ApiDoc::ResetPassword::Show

    let(:token) { Service::JWTAdapter.encode(aud: 'reset_password', sub: user.id, exp: 1.day.from_now.to_i) }
    let(:user) { create(:user) }
    let(:params) { { token: token } }

    before { get '/reset_password', params: params }

    describe 'Success' do
      it 'approves token as valid', :dox do
        expect(response).to be_no_content
        expect(response.body).to be_empty
      end
    end

    describe 'Fail' do
      context 'when token is expired' do
        let(:token) { Service::JWTAdapter.encode(aud: 'reset_password', sub: user.id, exp: -1.day.from_now.to_i) }

        it 'disallows token as invalid', :dox do
          expect(response).to have_http_status(:gone)
          expect(response.body).to be_empty
        end
      end

      context 'when token is not valid or there are no token at all' do
        let(:params) { {} }

        it 'disallows token as invalid', :dox do
          expect(response).to have_http_status(:gone)
          expect(response.body).to be_empty
        end
      end

      context 'when token has wrong aud' do
        let(:token) { Service::JWTAdapter.encode(aud: 'wrong', sub: user.id, exp: 1.day.from_now.to_i) }
        let(:params) { { token: token } }

        it 'disallows token as invalid', :dox do
          expect(response).to have_http_status(:gone)
          expect(response.body).to be_empty
        end
      end
    end
  end

  describe 'POST #create' do
    include ApiDoc::ResetPassword::Create

    let(:user) { create(:user) }

    before { post '/reset_password', params: params, as: :json }

    describe 'Success' do
      context 'when email registered' do
        let(:params) { { email: user.email } }

        it 'creates restore_password_token', :dox do
          expect(response).to be_created
          expect(response.body).to be_empty
        end
      end

      context "when email doesn't exist" do
        let(:params) { { email: 'not_existing_email@mail.com' } }

        it 'renders errors', :dox do
          expect(response).to be_created
          expect(response.body).to be_empty
        end
      end
    end

    describe 'Fail' do
      context "when email doesn't match regex" do
        let(:params) { { email: 'wrong_email' } }

        it 'renders errors', :dox do
          expect(response).to be_unprocessable
          expect(response).to match_json_schema('errors')
        end
      end
    end
  end

  describe 'PUT #update' do
    include ApiDoc::ResetPassword::Update

    let(:token) { Service::JWTAdapter.encode(aud: 'reset_password', sub: user.id, exp: 1.day.from_now.to_i) }
    let(:user) { create(:user) }

    before { put '/reset_password', params: params, as: :json }

    describe 'Success' do
      let(:params) { { token: token, password: 'Password1', password_confirmation: 'Password1' } }

      it "updates Employee's password with new one", :dox do
        expect(response).to be_no_content
        expect(response.body).to be_empty
      end
    end

    describe 'Failure' do
      context 'when token is invalid' do
        let(:params) { { token: 'invalid_token', password: 'Password1', password_confirmation: 'Password1' } }

        it 'returns errors', :dox do
          expect(response).to have_http_status(:gone)
          expect(response.body).to be_empty
        end
      end

      context "when password doesn't match regex" do
        let(:params) { { token: token, password: '11111111', password_confirmation: '11111111' } }

        it 'returns errors', :dox do
          expect(response).to be_unprocessable
          expect(response.body).to match_json_schema('errors')
        end
      end

      context 'when password length not corresponds requirements' do
        let(:params) { { token: token, password: '1', password_confirmation: '1' } }

        it 'returns errors', :dox do
          expect(response).to be_unprocessable
          expect(response.body).to match_json_schema('errors')
        end
      end

      context 'when password_confirmation is not equals password' do
        let(:params) { { token: token, password: 'Password1', password_confirmation: 'Password2' } }

        it 'returns errors', :dox do
          expect(response).to be_unprocessable
          expect(response.body).to match_json_schema('errors')
        end
      end

      context 'when token has no employee_id in payload' do
        let(:token) { Service::JWTAdapter.encode(aud: 'reset_password', exp: 1.day.from_now.to_i) }
        let(:params) { { token: token, password: 'Password1', password_confirmation: 'Password1' } }

        it 'returns errors', :dox do
          expect(response).to have_http_status(:gone)
          expect(response.body).to be_empty
        end
      end

      context 'when token has non existent employee_account_id in payload' do
        let(:token) do
          Service::JWTAdapter.encode(aud: 'reset_password', sub: User.ids.max.to_i + 1, exp: 1.day.from_now.to_i)
        end
        let(:params) { { token: token, password: 'Password1', password_confirmation: 'Password1' } }

        it 'returns errors', :dox do
          expect(response).to have_http_status(:gone)
          expect(response.body).to be_empty
        end
      end
    end
  end
end
