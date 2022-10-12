module V1
  class Auth < ::BaseApi
    resource :auth do
      desc 'register a new user'
      params do
        requires :email, type: String
        requires :password, type: String
      end

      post '/login_or_sign_up' do
        if current_user
          custom_json_error(I18n.t('error.already_logged_in'), 400)
        else
          login_or_sign_up_service = ::Auth::LoginOrSignUp.new(email: declared_params[:email], password: declared_params[:password])
          login_or_sign_up_service.call

          if login_or_sign_up_service.success?
            sign_in(login_or_sign_up_service.user)
            custom_json_render(login_or_sign_up_service.user, serializer: UserSerializer)
          else
            custom_json_error(login_or_sign_up_service.errors, 422)
          end
        end
      end

      desc 'logout a user'
      delete '/sign_out' do
        sign_out
        status 204
      end

      desc 'get current user'
      get '/current_user' do
        custom_json_render(current_user, serializer: UserSerializer) if current_user
      end
    end
  end
end
