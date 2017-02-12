require 'openssl'

module Authentication
  class TokenGenerator
    def initialize(key_generator, digest = "SHA256")
      @key_generator = key_generator
      @digest = digest
    end

    def digest(klass, column, value)
      value.present? && OpenSSL::HMAC.hexdigest(@digest, key_for(column), value.to_s)
    end

    def generate(klass, column)
      key = key_for(column)

      loop do
        raw = Token.friendly_token
        enc = OpenSSL::HMAC.hexdigest(@digest, key, raw)
        break [raw, enc] unless klass.to_adapter.find_first({ column => enc })
      end
    end

    private

    def key_for(column)
      @key_generator.generate_key("#{column}")
    end
  end

  mattr_accessor :token_generator
  @@token_generator = TokenGenerator.new(ActiveSupport::CachingKeyGenerator.new(ActiveSupport::KeyGenerator.new(ENV['TOKEN_SECRET'])))
end
