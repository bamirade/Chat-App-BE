module AuthHelper
  SECRET_KEY = ENV['SECRET_KEY_BASE']

  EXPIRATION_TIME = 168.hours.to_i

  def self.generate_token(user_id)
    expiration_time = Time.now.to_i + EXPIRATION_TIME
    payload = { user_id: user_id, exp: expiration_time }
    JWT.encode(payload, SECRET_KEY, 'HS256')
  end

  def self.decode_token(token)
    decoded_token = JWT.decode(token, SECRET_KEY, true, algorithm: 'HS256').first
    if decoded_token['exp'] && Time.now.to_i < decoded_token['exp']
      decoded_token
    else
      nil
    end
  rescue JWT::ExpiredSignature
    nil
  end
end
