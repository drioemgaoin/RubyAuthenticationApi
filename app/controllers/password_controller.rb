class PasswordController < ApplicationController
  include SwaggerPasswordController

  def reset
    reset_password_token = User.send_reset_password_token({ email: params[:email] })

    if !reset_password_token.nil?
      render json: {
        reset_password_token: reset_password_token,
        message: I18n.t("lock.reset_password_token")
      }
    else
      render_error I18n.t("failure.reset_password_token", provider: params[:provider])
    end
  end

  def reset_post
    user = User.reset_password_by_token(reset_params)

    if user.errors.empty?
      render json: {
        message: I18n.t("password.reset_password")
      }
    else
      render_error user.full_errors, :unprocessable_entity
    end
  end

  private
  def reset_params
    api_parameter_sanitizer.sanitize(:reset)
  end
end
