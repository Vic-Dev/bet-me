class User < ActiveRecord::Base

  validates :email, presence: true, uniqueness: true
  validates :first_name, presence: true
  validates :last_name, presence: true

  has_many :voters
  has_many :challenges, through: :voters

  has_secure_password

end
