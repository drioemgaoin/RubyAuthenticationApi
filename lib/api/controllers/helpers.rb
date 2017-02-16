module Api
  module Controllers
    module Helpers
      extend ActiveSupport::Concern

      included do
        if respond_to?(:helper_method)
          helper_method :warden, :signed_in?, :devise_controller?
        end
      end

      module ClassMethods
        def api_parameter_sanitizer
          @api_parameter_sanitizer ||= Api::ParameterSanitizer.new(resource_class, resource_name, params)
        end
      end
    end
  end
end
