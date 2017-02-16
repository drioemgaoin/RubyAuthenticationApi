class AuthenticationController < ApplicationController
  include SwaggerAuthenticationController

  def sign_up
    user = User.sign_up sign_up_params

    if user.persisted?
      render json: { token: user.access_token, message: I18n.t("authentication.signed_up") }
    else
      render_error user.full_errors, :unprocessable_entity
    end
  end

  def sign_in
    parameters = sign_in_params
    user = User.find_by email: parameters[:email] if parameters[:email].present?

    if user && user.valid_password?(parameters[:password])
      render json: { token: Token.encode(user.id), message: I18n.t("authentication.signed_in") }
    else
      render_error I18n.t("failure.signed_in_invalid"), :unprocessable_entity
    end
  end

  def authenticate
    oauth = "Oauth::#{params['provider'].titleize}".constantize.new(params)
    if oauth.authorized?
      user = User.from_auth(oauth.formatted_user_data)
      if user
        render_success(token: Token.encode(user.id), id: user.id, message: I18n.t("authentication.signed_in"))
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
