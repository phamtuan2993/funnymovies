module Api
  module Authenticable
    def current_user
      return @current_user if defined?(@current_user)

      # stub current_user
      @current_user = [User.order(Arel.sql('RANDOM()')).first, nil].sample
    end

    def authorize_user!
      custom_json_error(I18n.t('error.unauthenticated_request'), 401) unless current_user
    end
  end
end
