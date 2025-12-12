class Auth::PasswordsController < Devise::PasswordsController
  respond_to :json

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
