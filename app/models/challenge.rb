class Challenge < ActiveRecord::Base

  validates :title, presence: true
  validates :description, presence: true
  validates :wager, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true

  has_many :records
  has_many :users, through: :records

end
