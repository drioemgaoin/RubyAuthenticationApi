class User < ActiveRecord::Base
  include DatabaseAuthenticatable
  # include Validatable

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

  def self.from_auth(params, current_user)
    params = params.smash.with_indifferent_access
    authorization = Authorization.find_or_initialize_by(provider: params[:provider], uid: params[:uid])
    if authorization.persisted?
      if current_user
        if current_user.id == authorization.user.id
          user = current_user
        else
          return false
        end
      else
        user = authorization.user
      end
    else
      if current_user
        user = current_user
      elsif params[:email].present?
        user = User.find_or_initialize_by(email: params[:email])
      else
        user = User.new
      end
    end
    authorization.secret = params[:secret]
    authorization.token  = params[:token]
    fallback_name        = params[:name].split(" ") if params[:name]
    fallback_first_name  = fallback_name.try(:first)
    fallback_last_name   = fallback_name.try(:last)
    user.first_name    ||= (params[:first_name] || fallback_first_name)
    user.last_name     ||= (params[:last_name]  || fallback_last_name)

    if user.image_url.blank?
      user.image = Image.new(name: user.full_name, remote_file_url: params[:image_url])
    end

    user.password = Devise.friendly_token[0,10] if user.encrypted_password.blank?

    if user.email.blank?
      user.save(validate: false)
    else
      user.save
    end
    authorization.user_id ||= user.id
    authorization.save
    user
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

  def displayName= name
    self.display_name = name
  end
end
