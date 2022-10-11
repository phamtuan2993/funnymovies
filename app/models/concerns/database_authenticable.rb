module DatabaseAuthenticable
  extend ActiveSupport::Concern

  included do
    attr_accessor :password

    # hooks
    before_validation :downcase_email
    before_save :encrypt_password

    # validations
    validates :password, length: { minimum: 6, maximum: 255 }
    validates :email, presence: true
    validates :email,
      length: { minimum: 6, maximum: 255 },
      format: { with: URI::MailTo::EMAIL_REGEXP },
      uniqueness: true,
      allow_blank: true
  end

  # class methods
  module ClassMethods
    def valid_password?(verifying_password, user: nil, email: nil)
      user ||= email.presence && User.find_by_email(email)
      return false unless user

      BCrypt::Password.new(user.encrypted_password) == verifying_password
    end
  end

  # methods
  def valid_password?(verifying_password)
    self.class.valid_password?(verifying_password, user: self)
  end

  private

  def encrypt_password
    return unless new_record? || password_changed?

    self.encrypted_password = ::BCrypt::Password.create(password, cost: (ENV['ENCRYPT_COST'] || 6).to_i)
  end

  def downcase_email
    self.email.tap(&:strip!).tap(&:downcase!)
  end
end
