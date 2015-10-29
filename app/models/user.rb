class User < ActiveRecord::Base

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
  validates :password, presence: true, length: { minimum: 6 }, if: -> { password.present? }
  validates :password_confirmation, presence: true

end
