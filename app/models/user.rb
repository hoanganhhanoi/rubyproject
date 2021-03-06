class User < ActiveRecord::Base

  attr_accessor :remember_token

  before_save { self.email = email.downcase }

  validates :name, presence: true, length: { maximum: 50 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 }, 
             format: { with: VALID_EMAIL_REGEX },
             uniqueness: { case_sensitive: false }
            
  has_secure_password
  # truoc khi validates ta se kiem tra truong password hien tai bang lenh 
  # if: -> { password.present? }
  # vi vay ham has_secure_password se khong duoc goi neu password.present la false tuc la truong password da co gia tri nguoc voi blank? 
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true, if: -> { password.present? }
  validates :password_confirmation, presence: true

  # Remember token
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_token, User.digest(remember_token))
  end

  # Returns the hash digest of the given string
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Return new token
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # Return true if the given token matches the digest
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # Forget a user
  def forget
    update_attribute(:remember_digest, nil)
  end

end
