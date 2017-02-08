class ApplicationController < ActionController::API
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
  before_action :set_locale

  def set_locale
    I18n.locale = current_user.try(:locale) || I18n.default_locale
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
