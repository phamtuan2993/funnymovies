class Session < ApplicationRecord
  ACTIVE_SESSION_LIMIT = 10

  belongs_to :user

  before_create :generate_token
  after_create_commit :limit_active_sessions

  private

  def generate_token
    self.token ||= SecureRandom.hex(32)
  end

  def limit_active_sessions
    excessive_sessions_cnt = Session.where(user_id: user_id).count - ACTIVE_SESSION_LIMIT
    return unless excessive_sessions_cnt > 0

    Session
        .where(user_id: user_id)
        .order(updated_at: :asc)
        .limit(excessive_sessions_cnt)
        .delete_all
  rescue Exception => e
    Rails.logger.info('='*20)
    Rails.logger.error("#{e.message}\n↳ #{e.backtrace[0]}")
    Rails.logger.info('='*20)
  end
end
