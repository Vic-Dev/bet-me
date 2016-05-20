class Voter < ActiveRecord::Base

  validates :challenge_id, :user_id, :role, presence: true
  validates :accepted_invite, inclusion: { in: [true, false] }

  validates_uniqueness_of :challenge_id, scope: :user_id

  belongs_to :user
  belongs_to :challenge

end