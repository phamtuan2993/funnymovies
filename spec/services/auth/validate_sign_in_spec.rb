require 'rails_helper'

describe ::Auth::ValidateSignIn do
  let(:service) { described_class.new(email: email, password: password) }
  let(:email) { 'email@gmail.com' }
  let(:password) { 'validP@ssw0rd' }
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
