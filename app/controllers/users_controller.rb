class UsersController < ApplicationController
  before_action :user, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, only: %i[index show create update destroy]

  # GET /users or /users.json
  def index
    # users = User.all.paginate(page: params[:page], per_page: 10)
    users = User.all
    render json: {
      status: "success",
      data: users
    }, status: :ok
  end

  def me
    if user_signed_in?
      render json: {
        status: "success",
        data: current_user
      }, status: :ok
    else
      render json: {
        status: "error",
        error: "Haven't logged in!"
      }, status: :unauthorized
    end
    # byebug
  end

  # GET /users/1 or /users/1.json
  def show
    if user
      render json: {
        status: "success",
        data: user
      }, status: :ok
    else
      render json: {
        status: "error",
      }, status: :not_found
    end
  end

  # POST /users or /users.json
  def create
    user = User.new(user_params)
    unless user.password
      user.password = "123456"
      user.password_confirmation = "123456"
    end
    if user.save
      render json: {
        status: "success",
        data: user
      }, status: :created
    else
      render json: {
        status: "error",
        error: user.errors
      }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    if user.update(user_params)
      render json: {
        status: "success",
        data: user
      }
    else
      render json: {
        status: "error",
        error: user.errors
      }
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    if user.destroy
      render json: {
        status: "success",
        data: "Delete successfully! "
      }, status: :ok
    else
      render json: {
        status: "error",
        error: user.errors
      }, status: :unprocessable_entity
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def user
    @_user = User.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(User::USER_PARAMS)
  end
end
