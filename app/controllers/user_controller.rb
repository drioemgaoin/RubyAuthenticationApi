class UserController < ApplicationController
  include SwaggerUserController

  def get
    users = User.all.map{|u| {
      :email => u.email,
      :avatar => get_avatar_urls(u.avatar)
    }}

    if users
      render json: {
        users: users,
        message: I18n.t("lock.unlock_token")
      }
    else
      render_error I18n.t("failure.unlock_token", provider: params[:provider])
    end
  end

  private
  def get_avatar_urls avatar
    {
      :url => avatar.url,
      :thumb => avatar.url(:thumb),
      :small => avatar.url(:small),
      :medium => avatar.url(:medium)
    }
  end
end
