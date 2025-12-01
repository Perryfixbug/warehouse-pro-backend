class ApplicationController < ActionController::API
  # skip_before_action :verify_authenticity_token
  include Devise::Controllers::Helpers

  rescue_from CanCan::AccessDenied do |exception|
    render json: { 
      status: "error", 
      error: exception.message 
    }, status: :forbidden
  end
end
