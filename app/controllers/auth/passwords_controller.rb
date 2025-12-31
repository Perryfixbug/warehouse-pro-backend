class Auth::PasswordsController < Devise::PasswordsController
  respond_to :json

  def new
    user = User.with_reset_password_token(params[:reset_password_token])

    if user
      render json: { status: "success" }, status: :ok
    else
      render json: { status: "error" }, status: :not_found
    end
  end

  # POST /users/password
  def create
    user = User.find_by(email: params[:email])

    if user.nil?
      return render json: { status: "error", error: "Email không tồn tại" }, status: :not_found
    end
    
    user.send_reset_password_instructions

    render json: { 
      status: "success",
      message: "Email reset đã được gửi" 
    }, status: :ok
  end


  # PUT /users/password
  def update
    user = User.reset_password_by_token(reset_password_params)
    if user.errors.empty?
      RefreshToken
        .where(user_id: user.id, revoked_at: nil)
        .update_all(revoked_at: Time.current)

      render json: { 
        status: "success",
        message: "Đặt lại mật khẩu thành công" 
      }, status: :ok
    else
      render json: { 
        status: "error",
        errors: user.errors.full_messages 
      }, status: :unprocessable_entity
    end
  end

  private
  def reset_password_params
    params.permit(:reset_password_token, :password, :password_confirmation)
  end
end
