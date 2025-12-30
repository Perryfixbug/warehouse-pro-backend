class Auth::SessionsController < Devise::SessionsController
  prepend_before_action :check_captcha, only: [:create]
  respond_to :json

  private

  # LOGIN thành công
  def respond_with(resource, _opts = {})
    raw_refresh_token = TokenService.generate

    RefreshToken.create!(
      user: resource,
      token_digest: TokenService.digest(raw_refresh_token),
      expires_at: 30.days.from_now,
    )

    cookies.encrypted[:refresh_token] = {
      value: raw_refresh_token,
      httponly: true,
      secure: false,
      same_site: :lax,
      expires: 30.days.from_now
    }

    render json: {
      status: 'success',
      data: resource,
      token: request.env['warden-jwt_auth.token']
    }, status: :ok
  end

  # LOGOUT
  def respond_to_on_destroy
    if (raw = cookies.encrypted[:refresh_token])
      RefreshToken
        .where(token_digest: TokenService.digest(raw))
        .update_all(revoked_at: Time.current)
    end

    cookies.delete(:refresh_token)

    render json: { status: "success" }
  end

  def after_sign_in_path_for(_resource)
    nil
  end

  def after_sign_out_path_for(_resource_or_scope)
    nil
  end

  # CAPTCHA
  def check_captcha
    token = params.dig(:user, :captchaToken)
    return if RecaptchaService.verify(token)

    render json: {
      status: "error",
      error: "Fail to verify captcha"
    }, status: :unprocessable_entity
  end
end
