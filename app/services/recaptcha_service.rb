class RecaptchaService
  def self.verify(token, action = 'login')
    uri = URI('https://www.google.com/recaptcha/api/siteverify')
    response = Net::HTTP.post_form(uri, {
      secret: ENV["CAPTCHA_SECRET_KEY"],
      response: token
    })
    
    result = JSON.parse(response.body)
    byebug
    # Với reCAPTCHA v3, kiểm tra score (0.0 - 1.0)
    # Score càng cao càng có khả năng là người thật
    result['success'] && result['score'] >= 0.5
  end
end
