class AuthenticationController < ApplicationController
  include SwaggerAuthenticationController

  def sign_up
    user = User.create sign_up_params

    if user.persisted?
      render json: { message: I18n.t("authentication.signed_up") }
    else
      render_error user.full_errors, :unprocessable_entity
    end
  end

  def sign_in
    access_token = User.sign_in sign_in_params

    if access_token
      render json: { access_token: access_token, message: I18n.t("authentication.signed_in") }
    else
      render_error I18n.t("failure.signed_in_invalid"), :unprocessable_entity
    end
  end

  def authenticate
    oauth = "Oauth::#{params['provider'].titleize}".constantize.new(params)
    if oauth.authorized?
      access_token = User.from_auth(oauth.formatted_user_data)
      if access_token
        render_success(access_token: access_token, message: I18n.t("authentication.signed_in"))
      else
        render_error I18n.t("failure.account_already_used", provider: params[:provider])
      end
    else
      render_error I18n.t("failure.signed_in_failure", provider: params[:provider])
    end
  end

  private
    def sign_in_params
      api_parameter_sanitizer.sanitize(:sign_in)
    end

    def sign_up_params
      api_parameter_sanitizer.sanitize(:sign_up)
    end
end
