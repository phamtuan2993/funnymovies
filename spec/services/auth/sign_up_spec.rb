require 'rails_helper'

describe ::Auth::SignUp do
  let(:service) { described_class.new(email: email, password: password) }
  let(:email) { 'email@gmail.com' }
  let(:password) { 'validP@ssw0rd' }

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

      it 'does nothing and return errors' do
        expect { service.call }
          .not_to change { User.count }

        expect(service.success?).to be(false)
        expect(service.errors).not_to be_empty
      end
    end
  end
end
