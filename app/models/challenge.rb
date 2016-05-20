class Challenge < ActiveRecord::Base

  validates :title, presence: true
  validates :description, presence: true
  validates :wager, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :complete, inclusion: { in: [true, false] }

  has_many :voters
  has_many :users, through: :voters
  belongs_to :user

end
