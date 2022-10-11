class Session < ActiveRecord::SessionStore::Session
  ACTIVE_SESSION_LIMIT = 10

  after_create_commit :limit_active_sessions

  private

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
    Rails.logger.error(e)
    Rails.logger.info('='*20)
  end
end
