class Challenge < ActiveRecord::Base

  validates :title, presence: true
  validates :description, presence: true
  validates :wager, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true

end