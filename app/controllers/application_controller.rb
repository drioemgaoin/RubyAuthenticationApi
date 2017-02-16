class ApplicationController < ActionController::API
  before_action :set_locale

  def set_locale
    I18n.locale = I18n.default_locale #|| current_user.try(:locale)
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
    def api_parameter_sanitizer
      @api_parameter_sanitizer ||= Api::ParameterSanitizer.new(User, :user, params)
    end
end
