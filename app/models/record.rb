class Record < ActiveRecord::Base

  validates :challenge_id, presence: true
  validates :user_id, presence: true
  validates :role, presence: true

  belongs_to :user
  belongs_to :challenge

end
