module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    private

    def find_verified_user
      token = request.params[:token]
      return reject_unauthorized_connection unless token.present?

      begin
        user = Warden::JWTAuth::UserDecoder.new.call(token, :user, nil)
        return user if user
      rescue => e
        Rails.logger.error "JWT decode error: #{e}"
      end

      reject_unauthorized_connection
    end
  end
end
