class User < ApplicationRecord
  attr_accessor :remember_token
  has_secure_password
  has_many :orders, dependent: :destroy
  has_many :notifications, dependent: :destroy

  validates :fullname, presence: true, length: { maximum: 100 }
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }, if: :will_save_change_to_email?

  def remember
    @remember_token = User.new_token
    update_column(:remember_digest, User.digest(@remember_token))
  end

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")  # Metaprogramming lấy giá trị digest từ db
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end
  # Begin class method
  class << self
    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ?
              BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end
  # End class method
end
