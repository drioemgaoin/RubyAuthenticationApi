module Api
  module Models
    class MissingAttribute < StandardError
      def initialize(attributes)
        @attributes = attributes
      end

      def message
        "The following attribute(s) is (are) missing on your model: #{@attributes.join(", ")}"
      end
    end

    def self.config(mod, *accessors)
      class << mod; attr_accessor :available_configs; end
      mod.available_configs = accessors

      accessors.each do |accessor|
        mod.class_eval <<-METHOD, __FILE__, __LINE__ + 1
          def #{accessor}
            if defined?(@#{accessor})
              @#{accessor}
            elsif superclass.respond_to?(:#{accessor})
              superclass.#{accessor}
            else
              Api.#{accessor}
            end
          end
          def #{accessor}=(value)
            @#{accessor} = value
          end
        METHOD
      end
    end

    def api(*modules)
      options = modules.extract_options!.dup

      selected_modules = modules.map(&:to_sym).uniq.sort_by do |s|
        Api::ALL.index(s) || -1  # follow Api::ALL order
      end

      api_modules_hook! do
        include Api::Models::Authenticatable

        selected_modules.each do |m|
          mod = Api::Models.const_get(m.to_s.classify)

          if mod.const_defined?("ClassMethods")
            class_mod = mod.const_get("ClassMethods")
            extend class_mod

            if class_mod.respond_to?(:available_configs)
              available_configs = class_mod.available_configs
              available_configs.each do |config|
                next unless options.key?(config)
                send(:"#{config}=", options.delete(config))
              end
            end
          end

          include mod
        end

        self.api_modules |= selected_modules
        options.each { |key, value| send(:"#{key}=", value) }
      end
    end

    def self.check_fields!(klass)
      failed_attributes = []
      instance = klass.new

      klass.api_modules.each do |mod|
        constant = const_get(mod.to_s.classify)

        constant.required_fields(klass).each do |field|
          failed_attributes << field unless instance.respond_to?(field)
        end
      end

      if failed_attributes.any?
        fail Api::Models::MissingAttribute.new(failed_attributes)
      end
    end

    def api_modules_hook!
      yield
    end
  end
end

require 'api/models/authenticatable'
