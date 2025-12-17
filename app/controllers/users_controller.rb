class UsersController < ApplicationController
  before_action :authenticate_user!, only: %i[show create update destroy]
  load_and_authorize_resource except: :me

  # GET /users or /users.json
  def index
    users = Search::UserSearch.new(params, User.all).call
    users_per_page = users.paginate(page: params[:page] || 1, per_page: 10)
    render json: {
      status: "success",
      data: users_per_page,
      meta: {
        current_page: users_per_page.current_page,
        total_pages: users_per_page.total_pages
      }
    }, status: :ok
  end

  def me
    if user_signed_in?
      authorize! :read, current_user
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
    @_user ||= User.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(User::USER_PARAMS)
  end
end
