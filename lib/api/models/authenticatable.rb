module Api
  module Models
    module Authenticatable
      extend ActiveSupport::Concern

      included do
        class_attribute :api_modules, instance_writer: false
        self.api_modules ||= []
      end

      def self.required_fields(klass)
        []
      end

      module ClassMethods
        Api::Models.config(self, :authentication_keys, :request_keys, :strip_whitespace_keys,
          :case_insensitive_keys, :params_authenticatable)

        def find_or_initialize_with_error_by(attribute, value, error=:invalid)
          find_or_initialize_with_errors([attribute], { attribute => value }, error)
        end

        def find_first_by_auth_conditions(tainted_conditions, opts={})
          to_adapter.find_first(api_parameter_filter.filter(tainted_conditions).merge(opts))
        end

        def find_or_initialize_with_errors(required_attributes, attributes, error=:invalid)
          attributes = if attributes.respond_to? :permit!
            attributes.slice(*required_attributes).permit!.to_h.with_indifferent_access
          else
            attributes.with_indifferent_access.slice(*required_attributes)
          end
          attributes.delete_if { |key, value| value.blank? }

          if attributes.size == required_attributes.size
            record = find_first_by_auth_conditions(attributes)
          end

          unless record
            record = new

            required_attributes.each do |key|
              value = attributes[key]
              record.send("#{key}=", value)
              record.errors.add(key, value.present? ? error : :blank)
            end
          end

          record
        end

        protected

        def api_parameter_filter
          @api_parameter_filter ||= Api::ParameterFilter.new(case_insensitive_keys, strip_whitespace_keys)
        end
      end
    end
  end
end
