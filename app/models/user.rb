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

    user.password = Api.friendly_token[0,10] if user.encrypted_password.blank?

    raw, enc = Api.token_generator.generate(User, :access_token)
    user.access_token = enc

    if user.email.blank?
      user.save(validate: false)
    else
      user.save
    end
    authorization.user_id ||= user.id
    authorization.save
    raw
  end

  def self.sign_in(attributes={})
    user = User.find_by email: attributes[:email] if attributes[:email].present?
    return nil if !user || !user.valid_password?(attributes[:password])

    raw, enc = Api.token_generator.generate(User, :access_token)
    user.access_token = enc
    user.save(validate: false)
    raw
  end

  def full_errors
    errors.map { |k, v| v }
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
