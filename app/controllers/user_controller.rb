class UserController < ApplicationController
  include SwaggerUserController

  def get_all
    users = User.all

    if users
      render json: users
    else
      render_error I18n.t("failure.user_profile", provider: params[:provider])
    end
  end

  def get
    user = User.find_by_id(params[:id])

    if user
      render json: user
    else
      render_error I18n.t("failure.user_profile", provider: params[:provider])
    end
  end
end
