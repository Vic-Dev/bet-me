class Record < ActiveRecord::Base

  validates :challenge_id, :user_id, :role, presence: true
  validates :is_active, :is_completed, inclusion: { in: [true, false] }

  validate :is_creator

  validates_uniqueness_of :challenge_id, scope: :user_id

  belongs_to :user
  belongs_to :challenge

  private

  def is_creator
    if role == "creator" && !vote_result.nil?
      errors.add(:vote_result, "can't exist if role creator")
    end
  end

end