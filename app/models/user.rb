class User < ActiveRecord::Base
  api :database_authenticatable, :recoverable, :validatable,
    :lockable

  mount_uploader :avatar, AvatarUploader

  validates_integrity_of  :avatar
  validates_processing_of :avatar

  def self.for_oauth oauth
    oauth.get_data
    data = oauth.data

    user = find_by(oauth.provider => data[:id]) || find_or_create_by(email: data[:email]) do |u|
      u.password =  SecureRandom.hex
    end

    user.update(
      display_name: oauth.get_names.join(' '),
      email: data[:email],
      oauth.provider => data[:id]
    )

    user
  end

  def self.from_auth(params)
    params = params.smash.with_indifferent_access
    authorization = Authorization.find_or_initialize_by(provider: params[:provider], uid: params[:uid])
    if authorization.persisted?
      user = authorization.user
    else
      if params[:email].present?
        user = User.find_or_initialize_by(email: params[:email])
      else
        user = User.new
      end
    end
    authorization.secret    = params[:secret]
    authorization.token     = params[:token]
    fallback_name           = params[:name].split(" ") if params[:name]
    fallback_first_name     = fallback_name.try(:first)
    fallback_last_name      = fallback_name.try(:last)
    user.first_name       ||= (params[:first_name] || fallback_first_name)
    user.last_name        ||= (params[:last_name]  || fallback_last_name)
    user.provider           = params[:provider]
    user.remote_avatar_url  = params[:image_url]

    user.password = Token.friendly_token[0,10] if user.encrypted_password.blank?

    if user.email.blank?
      user.save(validate: false)
    else
      user.save
    end
    authorization.user_id ||= user.id
    authorization.save
    user
  end

  def full_errors
    errors.map { |k, v| v }
  end

  # Set up a pepper to generate the encrypted password.
  def self.pepper
    if defined?(@pepper)
      @pepper
    else
      '5a6612015d14f8becbbdcee58376ad8332a25cdbb787214de22cd7d0aa0f0195ea37b52d1355978fd834f144002f8d7f4b6f795dc41265acbd078776cf2674aa'
    end
  end

  def self.pepper=(value)
    @pepper = value
  end

  # The number of times to hash the password.
  def self.stretches
    if defined?(@stretches)
      @stretches
    else
      11
    end
  end

  def self.stretches=(value)
    @stretches = value
  end

  # Range validation for password length
  def self.password_length
    if defined?(@password_length)
      @password_length
    else
      6..128
    end
  end

  def self.password_length=(value)
    @password_length = value
  end

  # Regex to use to validate the email address
  def self.password_length
    if defined?(@email_regexp)
      @email_regexp
    else
      /\A[^@\s]+@[^@\s]+\z/
    end
  end

  def self.email_regexp=(value)
    @email_regexp = value
  end

  # Defines which key will be used when recovering the password for an account
  def self.reset_password_keys
    if defined?(@reset_password_keys)
      @reset_password_keys
    else
      [:email]
    end
  end

  def self.reset_password_keys=(value)
    @reset_password_keys = value
  end

  # Time interval you can reset your password with a reset password key
  def self.reset_password_within
    if defined?(@reset_password_within)
      @reset_password_within
    else
      6.hours
    end
  end

  def self.reset_password_within=(value)
    @reset_password_within = value
  end

  # When set to false, resetting a password does not automatically sign in a user
  def self.sign_in_after_reset_password
    if defined?(@sign_in_after_reset_password)
      @sign_in_after_reset_password
    else
      true
    end
  end

  def self.sign_in_after_reset_password=(value)
    @sign_in_after_reset_password = value
  end

  # Keys that should be case-insensitive.
  def self.case_insensitive_keys
    if defined?(@case_insensitive_keys)
      @case_insensitive_keys
    else
      [:email]
    end
  end

  def self.case_insensitive_keys=(value)
    @case_insensitive_keys = value
  end

  # Keys that should have whitespace stripped.
  def self.strip_whitespace_keys
    if defined?(@strip_whitespace_keys)
      @strip_whitespace_keys
    else
      [:email]
    end
  end

  def self.strip_whitespace_keys=(value)
    @strip_whitespace_keys = value
  end

  def displayName= name
    self.display_name = name
  end

  protected
    def parameter_filter
      @parameter_filter ||= ParameterFilter.new(case_insensitive_keys, strip_whitespace_keys)
    end

  private
    def avatar_size_validation
      errors[:avatar] << "should be less than 500KB" if avatar.size > 0.5.megabytes
    end
end
