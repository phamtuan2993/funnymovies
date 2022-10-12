module Helpers
  module Authenticable
    SESSION_KEY = '_funny_movies_session'

    def current_user
      return @_current_user if defined?(@_current_user)

      return @_current_user = nil unless current_session

      @_current_user = User.find(current_session.user_id)
    end

    def authorize_user!
      custom_json_error(I18n.t('error.unauthenticated_request'), 401) unless current_user
    end

    def sign_in(user)
      cookies.delete(SESSION_KEY)

      create_session_service = ::Auth::CreateSession.new(user: user).tap(&:call)
      if create_session_service.success?
        @_current_user = user
        cookies[SESSION_KEY] = {
          value: create_session_service.session.token,
          path: '/',
          httponly: true,
          same_site: :strict
        }
      else
        custom_json_error(I18n.t('error.failed_to_login'), 500)
      end
    end

    def sign_out
      current_session&.delete
      cookies.delete(SESSION_KEY)
    end

    def current_session
      return @_current_session if defined?(@_current_session)

      return @_current_session = nil unless cookies[SESSION_KEY]

      @_current_session = Session.find_by_token(cookies[SESSION_KEY])
    end
  end
end
