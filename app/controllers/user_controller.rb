class UserController < ApplicationController
  include SwaggerUserController

  def get
    users = User.all.map{|u| {
      :email => u.email,
      :first_name => u.first_name,
      :last_name => u.last_name,
      :avatar => get_avatar_urls(u.avatar)
    }}

    if users
      render json: {
        users: users,
        message: I18n.t("user.profiles")
      }
    else
      render_error I18n.t("failure.user_profiles", provider: params[:provider])
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
