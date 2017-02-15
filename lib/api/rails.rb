module Api
  class Engine < ::Rails::Engine
    config.api = Api

    initializer "api.secret_key" do |app|
      if app.respond_to?(:secrets)
        Api.secret_key ||= app.secrets.secret_key_base
      elsif app.config.respond_to?(:secret_key_base)
        Api.secret_key ||= app.config.secret_key_base
      end

      Api.token_generator ||=
        if secret_key = Api.secret_key
          Api::TokenGenerator.new(
            ActiveSupport::CachingKeyGenerator.new(ActiveSupport::KeyGenerator.new(secret_key))
          )
        end
    end
  end
end
