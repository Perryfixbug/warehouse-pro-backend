# config/initializers/recaptcha.rb
Recaptcha.configure do |config|
  config.site_key = ENV["CAPTCHA_SITE_KEY"]
  config.secret_key = ENV["CAPTCHA_SECRET_KEY"]
end