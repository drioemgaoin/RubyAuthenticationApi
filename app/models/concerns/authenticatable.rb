module Authenticatable
  extend ActiveSupport::Concern

  def self.required_fields(klass)
    []
  end

  module ClassMethods
    def find_first_by_auth_conditions(tainted_conditions, opts={})
      to_adapter.find_first(parameter_filter.filter(tainted_conditions).merge(opts))
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
  end
end
