class NotificationsController < ApplicationController
  def index
    render json: {
      status: "success",
      data: current_user.notifications.order(created_at: :desc)
    }, status: :ok
  end

  # Mark all read
  def create
    if current_user.notifications.update(read: true)
      render json: {
        status: "success",
        data: current_user.notifications
      }, status: :ok
    else
      render json: {
        status: "error"
      }, status: :unprocessable_entity
    end
  end

  # Mark a notification read
  def update
    notification = current_user.notifications.find(params[:id])
    if notification && notification.update(read: true)
      render json: {
        status: "success",
        data: notification
      }, status: :ok
    else
      render json: {
        status: "error"
      }, status: :unprocessable_entity
    end
  end
end
