class AuthController < ApplicationController

  def render_data(data, status)
    render json: data, status: status, callback: params[:callback]
  end

  def render_error(message, status = :unprocessable_entity)
    render_data({ error: message }, status)
  end

  def render_success(data, status = :ok)
    if data.is_a? String
      render_data({ message: data }, status)
    else
      render_data(data, status)
    end
  end

  def signup
    @user = User.create auth_params
    render json: { token: Token.encode(@user.id), message: message: I18n.t("authentication.signed_up") }
  end

  def login
    @user = User.find_by email: params[:email] if params[:email].present?

    if @user && @user.authenticate(params[:password])
      render json: { token: Token.encode(@user.id), message: I18n.t("authentication.signed_in") }
    else
      render json: { message: I18n.t("failure.signed_in_invalid") }, status: :unauthorized
    end
  end

  def authenticate
    @oauth = "Oauth::#{params['provider'].titleize}".constantize.new(params)
    if @oauth.authorized?
      @user = User.from_auth(@oauth.formatted_user_data, current_user)
      if @user
        render_success(token: Token.encode(@user.id), id: @user.id, message: I18n.t("authentication.signed_in"))
      else
        render_error I18n.t("failure.account_already_used", provider: params[:provider])
      end
    else
      render_error I18n.t("failure.signed_in_failure", provider: params[:provider])
    end
  end

  private
    def auth_params
      params.require(:auth).permit(:email, :password, :displayName)
    end
end
