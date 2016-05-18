class User < ActiveRecord::Base

  validates :email, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true

  has_many :records
  has_many :challenges, through: :records

  has_secure_password

end