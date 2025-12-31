class Auth::RefreshsController < ApplicationController
  def create
    raw_token = cookies.encrypted[:refresh_token]
    return unauthorized_response unless raw_token

    token = RefreshToken.active
      .find_by(token_digest: TokenService.digest(raw_token))

    return unauthorized_response unless token

    user = token.user

    # 🔁 ROTATE TOKEN
    token.revoke!

    new_raw_token = TokenService.generate
    RefreshToken.create!(
      user: user,
      token_digest: TokenService.digest(new_raw_token),
      expires_at: 30.days.from_now
    )

    cookies.encrypted[:refresh_token] = {
      value: new_raw_token,
      httponly: true,
      secure: Rails.env.production?,
      same_site: :lax,
      expires: 30.days.from_now
    }

    access_token, _payload =
      Warden::JWTAuth::UserEncoder.new.call(user, :user, nil)

    render json: {
      status: "success",
      data: access_token
    }, status: :ok
  end

  private

  def unauthorized_response
    cookies.delete(:refresh_token)
    render json: {
      status: "error",
      error: "Unauthorized"
    }, status: :unauthorized
  end
end
