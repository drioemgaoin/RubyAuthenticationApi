class PasswordController < ApplicationController
  include SwaggerPassword

  def reset
    unlock_token = User.send_reset_password_token({ email: params[:email] })

    if !unlock_token.nil?
      render json: {
        unlock_token: unlock_token,
        message: I18n.t("lock.unlock_token")
      }
    else
      render_error I18n.t("failure.unlock_token", provider: params[:provider])
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
    params.require(:user).permit(:reset_password_token, :password, :password_confirmation)
  end
end
