class Users::SessionsController < Devise::SessionsController
  respond_to :json

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
