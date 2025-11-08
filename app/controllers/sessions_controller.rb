class SessionsController < ApplicationController
  include SessionsHelper
  layout "auth", only: %i[new create destroy]
  
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email])
    if user && user.authenticate(params[:session][:password])
      log_in(user)
      params[:session][:remember_me] == "1" ? remember(user) : forget(user)
      redirect_to root_url
    else
      render :new
    end
  end

  def destroy
  end
end
