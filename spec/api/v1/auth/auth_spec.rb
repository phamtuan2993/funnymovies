require 'rails_helper'

describe V1::Auth do
  let(:json_response) { JSON.parse(response.body) }

  describe 'POST /sign_up' do
    before do
      allow(::Auth::SignUp).to receive(:new).and_call_original
      allow_any_instance_of(::Auth::SignUp).to receive(:call)
      allow_any_instance_of(::Auth::SignUp).to receive(:user).and_return(user)
    end

    let(:user) { build(:user) }
    let(:email) { 'email@gmail.com' }
    let(:password) { 'validP@ssw0rd' }

    it 'calls service and return result' do
      post '/api/v1/auth/sign_up', params: { email: email, password: password }

      expect(::Auth::SignUp).to have_received(:new).with(email: email, password: password)

      expect(response.status).to eq(201)
      # expect user being signed in
    end

    context 'service returns errors' do
      before do
        allow(::Auth::SignUp).to receive(:new).and_return(
          instance_double(
            ::Auth::SignUp,
            call: nil,
            success?: false,
            errors: ['some error']
          )
        )
      end

      it 'calls service and return errors' do
        post '/api/v1/auth/sign_up', params: { email: email, password: password }

        expect(::Auth::SignUp).to have_received(:new).with(email: email, password: password)

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
end
