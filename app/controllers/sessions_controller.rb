class SessionsController < Devise::SessionsController
  respond_to :json

  private

  # Override Devise method để trả JWT khi login thành công
  def respond_with(resource, _opts = {})
    render json: {
      status: "success",
      data: resource,
      token: request.env['warden-jwt_auth.token'] # JWT được Devise thêm vào env
    }, status: :ok
  end

  def respond_to_on_destroy
    head :no_content

    render json: {
      status: "success"
    }, status: :no_content
  end

  # Important: prevent Devise from redirecting after sign in
  def after_sign_in_path_for(resource)
    nil
  end

  def after_sign_out_path_for(resource_or_scope)
    nil
  end
end
