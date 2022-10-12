require 'rails_helper'

describe V1::Auth do
  let(:json_response) { JSON.parse(response.body) }

  describe 'POST /login_or_sign_up' do
    before do
      allow(::Auth::LoginOrSignUp).to receive(:new).and_call_original
    end

    let(:email) { 'email@gmail.com' }
    let(:password) { 'validP@ssw0rd' }
    let(:session) { Session.last }

    context 'new email' do
      let(:user) { User.last }

      it 'calls service and returns result' do
        expect {
          post '/api/v1/auth/login_or_sign_up', params: { email: email, password: password }
        }.to change { User.count }.by(1)
        .and change { Session.count }.by(1)

        expect(::Auth::LoginOrSignUp).to have_received(:new).with(email: email, password: password)

        expect(response.status).to eq(201)
        expect(cookies['_funny_movies_session']).to eq(session.token)
        expect(session.user).to eq(user)
      end

      context 'service returns errors' do
        before do
          allow(::Auth::LoginOrSignUp).to receive(:new).and_return(
            instance_double(
              ::Auth::LoginOrSignUp,
              call: nil,
              success?: false,
              errors: ['some error']
            )
          )
        end

        it 'calls service and returns errors' do
          post '/api/v1/auth/login_or_sign_up', params: { email: email, password: password }

          expect(::Auth::LoginOrSignUp).to have_received(:new).with(email: email, password: password)

          expect(response.status).to eq(422)
          expect(json_response['error']).to include(
            'code' => 422,
            'errors' => [{
              'message' => 'some error'
            }]
          )
        end
      end
    end

    context 'existing email' do
      let!(:user) { create(:user, email: email, password: password) }

      it 'calls service and returns result' do
        expect {
          post '/api/v1/auth/login_or_sign_up', params: { email: email, password: password }
        }.to change { Session.count }.by(1)

        expect(::Auth::LoginOrSignUp).to have_received(:new).with(email: email, password: password)

        expect(response.status).to eq(201)
        expect(cookies['_funny_movies_session']).to eq(session.token)
        expect(session.user).to eq(user)
      end

      context 'service returns errors' do
        before do
          allow(::Auth::LoginOrSignUp).to receive(:new).and_return(
            instance_double(
              ::Auth::LoginOrSignUp,
              call: nil,
              success?: false,
              errors: ['some errors']
            )
          )
        end

        it 'calls service and returns errors' do
          post '/api/v1/auth/login_or_sign_up', params: { email: email, password: password }

          expect(::Auth::LoginOrSignUp).to have_received(:new).with(email: email, password: password)

          expect(response.status).to eq(422)
          expect(json_response['error']).to include(
            'code' => 422,
            'errors' => [{
              'message' => 'some errors'
            }]
          )
        end
      end
    end
  end
end
