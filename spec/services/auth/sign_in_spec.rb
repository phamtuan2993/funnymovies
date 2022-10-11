require 'rails_helper'

describe ::Auth::SignIn do
  let(:service) { described_class.new(user: user) }
  let(:user) { create(:user) }

  it 'creates a new session for given user' do
    expect { service.call }
      .to change { Session.count }.by(1)

    session = Session.order(created_at: :asc).last

    expect(session.user).to eq(user)
  end

  context 'bad cases' do
    context 'given data is invalid' do
      let(:user) { nil }

      it 'does nothing and return errors' do
        expect { service.call }
          .not_to change { Session.count }

        expect(service.success?).to be(false)
        expect(service.errors).not_to be_empty
      end
    end
  end
end
