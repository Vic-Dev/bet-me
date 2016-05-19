class Record < ActiveRecord::Base

  validates :challenge_id, presence: true
  validates :user_id, presence: true
  validates :role, presence: true

  validates_uniqueness_of :challenge_id, scope: :user_id

  belongs_to :user
  belongs_to :challenge

end
