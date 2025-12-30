class JWT_Service
  class << self
    def encode(payload, secret, exp)
      payload[:exp] = exp.to_i
      JWT.encode(payload, secret, 'HS256')
    end

    def decode(token, secret)
      JWT.decode(token, secret, true, algorithm: 'HS256').first
    rescue JWT::ExpiredSignature, JWT::DecodeError
      nil
    end
  end
end
