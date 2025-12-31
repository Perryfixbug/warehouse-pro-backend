require 'digest'

class TokenService
  class << self
    def generate
      SecureRandom.hex(64)
    end
    
    def digest(token)
      Digest::SHA256.hexdigest(token)
    end
  end
end
