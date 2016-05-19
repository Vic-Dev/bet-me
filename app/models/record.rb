class Record < ActiveRecord::Base

  validates :challenge_id, :user_id, :role, presence: true
  validates :is_active, :is_completed, inclusion: { in: [true, false] }

  validate :is_creator
  validate :both_active_and_completed
  validate :not_active_or_completed

  validates_uniqueness_of :challenge_id, scope: :user_id

  belongs_to :user
  belongs_to :challenge

  private

  def is_creator
    if role == "creator" && !vote_result.nil?
      errors.add(:vote_result, "can't exist if role creator")
    end
  end

  def both_active_and_completed
    if (is_active && is_completed)
      errors.add(:record, "can't be both active and complete")
    end
  end

  def not_active_or_completed
    errors.add(:record, "must be either active or complete") unless is_active || is_completed
  end

end