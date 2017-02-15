require 'active_support/dependencies'
require 'orm_adapter'

module Api
  autoload :ParameterFilter,    'api/parameter_filter'
  autoload :TokenGenerator,     'api/token_generator'

  # Secret key used by the key generator
  mattr_accessor :secret_key
  @@secret_key = nil

  # Keys used when authenticating a user.
  mattr_accessor :authentication_keys
  @@authentication_keys = [:email]

  # Request keys used when authenticating a user.
  mattr_accessor :request_keys
  @@request_keys = []

  # Keys that should have whitespace stripped.
  mattr_accessor :strip_whitespace_keys
  @@strip_whitespace_keys = [:email]

  # Keys that should be case-insensitive.
  mattr_accessor :case_insensitive_keys
  @@case_insensitive_keys = [:email]

  # If params authenticatable is enabled by default.
  mattr_accessor :params_authenticatable
  @@params_authenticatable = true

  # Stores the token generator
  mattr_accessor :token_generator
  @@token_generator = Api::TokenGenerator.new(
    ActiveSupport::CachingKeyGenerator.new(ActiveSupport::KeyGenerator.new(ENV['SECRET_KEY_BASE']))
  )

  # Used to hash the password. Please generate one with rake secret.
  mattr_accessor :pepper
  @@pepper = nil

  # The number of times to hash the password.
  mattr_accessor :stretches
  @@stretches = 11

  # Defines which key will be used when recovering the password for an account
  mattr_accessor :reset_password_keys
  @@reset_password_keys = [:email]

  # Time interval you can reset your password with a reset password key
  mattr_accessor :reset_password_within
  @@reset_password_within = 6.hours

  # Email regex used to validate email formats. It asserts that there are no
  # @ symbols or whitespaces in either the localpart or the domain, and that
  # there is a single @ symbol separating the localpart and the domain.
  mattr_accessor :email_regexp
  @@email_regexp = /\A[^@\s]+@[^@\s]+\z/

  # Range validation for password length
  mattr_accessor :password_length
  @@password_length = 6..128

  # Constants which holds devise configuration for extensions. Those should
  # not be modified by the "end user" (this is why they are constants).
  ALL         = []

  def self.setup
    yield self
  end

  class Getter
    def initialize(name)
      @name = name
    end

    def get
      ActiveSupport::Dependencies.constantize(@name)
    end
  end

  def self.ref(arg)
    ActiveSupport::Dependencies.reference(arg)
    Getter.new(arg)
  end

  # Generate a friendly string randomly to be used as token.
  # By default, length is 20 characters.
  def self.friendly_token(length = 20)
    # To calculate real characters, we must perform this operation.
    # See SecureRandom.urlsafe_base64
    rlength = (length * 3) / 4
    SecureRandom.urlsafe_base64(rlength).tr('lIO0', 'sxyz')
  end

  # constant-time comparison algorithm to prevent timing attacks
  def self.secure_compare(a, b)
    return false if a.blank? || b.blank? || a.bytesize != b.bytesize
    l = a.unpack "C#{a.bytesize}"

    res = 0
    b.each_byte { |byte| res |= byte ^ l.shift }
    res == 0
  end
end

require 'api/models'
require 'api/rails'
