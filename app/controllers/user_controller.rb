class UserController < ApplicationController
  include SwaggerUserController

  def get
    users = User.all.map{|u| {
      :id => u.id,
      :email => u.email,
      :first_name => u.first_name,
      :last_name => u.last_name,
      :avatar => get_avatar_urls(u.avatar)
    }}

    if users
      render json: {
        users: users,
        message: I18n.t("user.profile")
      }
    else
      render_error I18n.t("failure.user_profile", provider: params[:provider])
    end
  end

  def get
    user = User.find_by_id(params[:id])

    if user
      user = {
        :id => user.id,
        :email => user.email,
        :first_name => user.first_name,
        :last_name => user.last_name,
        :avatar => get_avatar_urls(user.avatar)
      }

      render json: {
        user: user,
        message: I18n.t("user.profile")
      }
    else
      render_error I18n.t("failure.user_profile", provider: params[:provider])
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
