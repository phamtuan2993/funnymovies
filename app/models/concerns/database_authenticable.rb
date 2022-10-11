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

  module ClassMethods
    # class methods
    def self.valid_password?(verifying_password, user:, email:)
      user ||= email.presence && User.find_by_email(email)
      return false unless user

      BCrypt::Password.new(encrypted_password) == verifying_password
    end
  end

  # methods
  def valid_password?(verifying_password)
    self.class.valid_password?(verifying_password, user: self)
  end

  private

  ENCRYPT_COST = 6

  def encrypt_password
    self.encrypted_password = ::BCrypt::Password.create(password, cost: ENCRYPT_COST) if new_record? || password_changed?
  end

  def downcase_email
    self.email.tap(&:strip!).tap(&:downcase!)
  end
end
