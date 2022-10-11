module Auth
  class ValidateSignIn < ::ServiceBase
    attr_reader :email, :password, :user, :session

    def initialize(email:, password:)
      super
      @email = email
      @password = password
    end

    def call
      @user = User.find_by_email(email)
      add_error(I18n.t('error.failed_to_login')) unless @user&.valid_password?(password)
    end
  end
end
