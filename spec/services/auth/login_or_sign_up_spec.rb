require 'rails_helper'

describe ::Auth::LoginOrSignUp do
  let(:service) { described_class.new(email: email, password: password) }
  let(:email) { 'email@gmail.com' }
  let(:password) { 'validP@ssw0rd' }

  context 'new email' do
    it 'creates a new users given email and password' do
      expect { service.call }
        .to change { User.count }.by(1)

      user = User.order(created_at: :asc).last

      expect(user.email).to eq(email)
      expect(user.valid_password?(password)).to be(true)
    end

    context 'bad cases' do
      context 'given data is invalid' do
        let(:email) { 'not_a_valid_email' }

        it 'does nothing and returns errors' do
          expect { service.call }
            .not_to change { User.count }

          expect(service.success?).to be(false)
          expect(service.errors).not_to be_empty
        end
      end
    end
  end

  context 'existing email' do
    let!(:user) { create(:user, email: email, password: password) }

    it 'validate given email and password' do
      service.call

      expect(service.success?).to be(true)
    end

    context 'bad cases' do
      context 'given data is invalid' do
        let(:service) { described_class.new(email: email, password: 'not valid password') }

        it 'returns errors' do
          service.call

          expect(service.success?).to be(false)
          expect(service.errors).not_to be_empty
        end
      end
    end
  end
end
