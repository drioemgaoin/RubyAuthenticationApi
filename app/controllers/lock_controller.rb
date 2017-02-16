class LockController < ApplicationController
  include SwaggerLockController

  def lock
    unlock_token = User.send_unlock_instructions(lock_params)

    if !unlock_token.nil?
      render json: {
        unlock_token: unlock_token,
        message: I18n.t("lock.lock")
      }
    else
      render_error I18n.t("failure.lock_failed", provider: params[:provider])
    end
  end

  def unlock
    user = User.unlock_access_by_token(unlock_params)

    if user.errors.empty?
      render json: {
        message: I18n.t("lock.unlock")
      }
    else
      render_error I18n.t("failure.unlock_failed", provider: params[:provider])
    end
  end

  def lock_params
    params.require(:user).permit(:email)
  end

  def unlock_params
    params.require(:user).permit(:unlock_token)
  end
end
