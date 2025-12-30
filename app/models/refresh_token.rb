class RefreshToken < ApplicationRecord
  belongs_to :user

  scope :active, -> {
    where(revoked_at: nil)
      .where("expires_at > ?", Time.current)
  }

  def revoke!
    update!(revoked_at: Time.current)
  end
end
