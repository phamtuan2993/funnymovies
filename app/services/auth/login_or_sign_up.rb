module Auth
  class LoginOrSignUp < ::ServiceBase
    attr_reader :email, :password, :user

    def initialize(email:, password:)
      super
      @email = email
      @password = password
    end

    def call
      @user = User.find_by_email(email)
      if @user.nil?
        @user = User.create(email: email, password: password)
        add_error(@user.errors.full_messages) if @user.errors.any?
      else
        add_error(I18n.t('error.failed_to_login')) unless @user&.valid_password?(password)
      end
    end
  end
end
