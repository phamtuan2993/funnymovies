module V1
  class Auth < ::BaseApi
    resource :auth do
      desc 'register a new user'
      params do
        requires :email, type: String
        requires :password, type: String
      end

      post '/sign_up' do
        sign_up_service = ::Auth::SignUp.new(email: declared_params[:email], password: declared_params[:password])
        sign_up_service.call

        if sign_up_service.success?
          sign_in(sign_up_service.user)
          custom_json_render(sign_up_service.user)
        else
          custom_json_error(sign_up_service.errors, 422)
        end
      end

      desc 'login a user'
      params do
        requires :email, type: String
        requires :password, type: String
      end

      post '/sign_in' do
        if current_user
          custom_json_error(I18n.t('error.already_logged_in'), 400)
        else
          validate_sign_in_service = ::Auth::ValidateSignIn.new(email: declared_params[:email], password: declared_params[:password])
          validate_sign_in_service.call

          if validate_sign_in_service.success?
            sign_in(validate_sign_in_service.user)
            custom_json_render(validate_sign_in_service.user)
          else
            custom_json_error(validate_sign_in_service.errors, 422)
          end
        end
      end
    end
  end
end
