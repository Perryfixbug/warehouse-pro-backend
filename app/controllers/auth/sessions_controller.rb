class Auth::SessionsController < Devise::SessionsController
  prepend_before_action :check_captcha, only: [ :create ]

  protected
  def check_captcha
    recaptcha_token = params[:user][:captchaToken]
    unless RecaptchaService.verify(recaptcha_token)
      render json: {
        status: "error",
        error: "Fail to verify captcha"
      }, status: :unprocessable_entity
      return
    end
  end

  # LOGIN thành công
  private
  def respond_with(resource, _opts = {})
    render json: {
      status: 'success',
      data: resource,
      token: request.env['warden-jwt_auth.token']
    }, status: :ok
  end

  # LOGOUT
  def respond_to_on_destroy
    if current_user
      render json: { status: 'success', message: 'Logged out' }, status: :ok
    else
      render json: { status: 'error', message: 'User already logged out' }, status: :unauthorized
    end
  end

  # Ngăn Devise redirect (không cần đường dẫn)
  def after_sign_in_path_for(resource)
    nil
  end

  def after_sign_out_path_for(resource_or_scope)
    nil
  end
end
