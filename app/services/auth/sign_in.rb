module Auth
  class SignIn < ::ServiceBase
    attr_reader :user, :session

    def initialize(user:)
      super
      @user = user
    end

    def call
      @session = Session.create(user: user)
      add_error(@session.errors.full_messages) if @session.errors.any?
    end
  end
end
