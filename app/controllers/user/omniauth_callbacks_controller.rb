class User::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_authorization_check

  def method_missing(provider)
    if !User.omniauth_providers.index(provider).nil?
      omniauth = request.env["omniauth.auth"]
      omniauth = env["omniauth.auth"]

      if current_user.present? #or User.find_by_email(auth.recursive_find_by_key("email"))
        current_user.user_tokens.find_or_create_by_provider_and_uid(omniauth['provider'], omniauth['uid'].to_s)
        flash[:notice] = "Authentication successful"
        redirect_to edit_user_registration_path
      else

        authentication = UserToken.find_by_provider_and_uid(omniauth['provider'].to_s, omniauth['uid'].to_s)

        if authentication
          flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => omniauth['provider']
          #sign_in_and_redirect(:user, authentication.user)
          #sign_in_and_redirect(:user, authentication.user)
          sign_in_and_redirect authentication.user, :event => :authentication
        else

          #create a new user
          unless omniauth.recursive_find_by_key("email").blank?
            user = User.find_or_initialize_by_email(:email => omniauth.recursive_find_by_key("email"))
          else
            user = User.new
          end

          user.apply_omniauth(omniauth)
          #user.confirm! #unless user.email.blank?

          if user.save
            flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => omniauth['provider'] 
            sign_in_and_redirect user, :event => :authentication
          else
            raise "User has errors: #{user.errors.full_messages} with #{user.inspect}"
            session[:omniauth] = omniauth.except('extra')
            redirect_to new_user_registration_url
          end
        end
      end
    end
  end
end
