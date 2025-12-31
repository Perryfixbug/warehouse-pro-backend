class CleanupRefreshTokensJob
  include Sidekiq::Job

  sidekiq_options queue: :maintenance, retry: false
  CUTOFF = 1.week.ago

  def perform
    deleted = RefreshToken
      .where("expires_at < ?", CUTOFF)
      .or(
        RefreshToken.where("revoked_at < ?", CUTOFF)
      )
      .delete_all

    Rails.logger.info(
      "[CleanupRefreshTokensJob] Deleted #{deleted} refresh tokens"
    )
  end
end
