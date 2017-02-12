class ApplicationController < ActionController::API
  before_action :set_locale

  def set_locale
    I18n.locale = current_user.try(:locale) || I18n.default_locale
  end

  def render_data(data, status)
    render json: data, status: status, callback: params[:callback]
  end

  def render_error(errors, status = :unprocessable_entity)
    render_data({ errors: errors }, status)
  end

  def render_success(data, status = :ok)
    if data.is_a? String
      render_data({ message: data }, status)
    else
      render_data(data, status)
    end
  end

  private
    def authenticate_user!
      unauthorized! unless current_user
    end

    def unauthorized!
      head :unauthorized
    end

    def current_user
      @current_user
    end

    def set_current_user
      token = request.headers['Authorization'].to_s.split(' ').last
      return unless token

      payload = Token.new(token)

      @current_user = User.find(payload.user_id) if payload.valid?
    end
end
