class Token
  attr_reader :user_id, :payload

  def initialize token
    @payload = JWT.decode(token, ENV['TOKEN_SECRET'], ENV['ALGORITHM']).first.with_indifferent_access
    @user_id = @payload[:user_id]
  end

  def valid?
    user_id.presence && Time.now < Time.at(@payload[:exp].to_i)
  end

  def self.encode user_id
    JWT.encode({ user_id: user_id, exp: (DateTime.now + 30).to_i }, ENV['TOKEN_SECRET'], ENV['ALGORITHM'])
  end

  def self.friendly_token(length = 20)
    rlength = (length * 3) / 4
    SecureRandom.urlsafe_base64(rlength).tr('lIO0', 'sxyz')
  end
end
