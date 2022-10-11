module Api
  module Authenticable
    def current_user
      return @_current_user if defined?(@_current_user)

      return @_current_user = nil unless current_session

      @_current_user = User.find(current_session.user_id)
    end

    def authorize_user!
      custom_json_error(I18n.t('error.unauthenticated_request'), 401) unless current_user
    end

    def sign_in(user)
      cookies.delete('_funny_movies_session')

      create_session_service = ::Auth::CreateSession.new(user: user).tap(&:call)
      if create_session_service.success?
        @current_user = user
        cookies['_funny_movies_session'] = {
          value: create_session_service.session.token,
          path: '/',
          httponly: true,
          same_site: :strict
        }
      else
        custom_json_error(I18n.t('error.failed_to_login'), 500)
      end
    end

    def current_session
      return @_current_session if defined?(@_current_session)

      return @_current_session = nil unless cookies['_funny_movies_session']

      @_current_session = Session.find_by_token(cookies['_funny_movies_session'])
    end
  end
end
