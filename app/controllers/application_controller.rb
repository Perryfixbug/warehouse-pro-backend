class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  skip_before_action :verify_authenticity_token

  rescue_from CanCan::AccessDenied do |exception|
    render json: { 
      status: "error", 
      error: exception.message 
    }, status: :forbidden
  end
end
