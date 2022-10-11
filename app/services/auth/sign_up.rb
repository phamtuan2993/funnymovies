module Auth
  class SignUp < ::ServiceBase
    attr_reader :email, :password, :user

    def initialize(email:, password:)
      super
      @email = email
      @password = password
    end

    def call
      @user = User.create(email: email, password: password)
      add_error(@user.errors.full_messages) if @user.errors.any?
    end
  end
end
