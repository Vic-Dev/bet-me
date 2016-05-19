class Record < ActiveRecord::Base

  validates :challenge_id, :user_id, :role, presence: true
  validates :challenge_completed, :accepted_invite, inclusion: { in: [true, false] }

  validate :is_creator
  validate :is_voter

  validates_uniqueness_of :challenge_id, scope: :user_id

  belongs_to :user
  belongs_to :challenge

  private

  def is_creator
    if role == "creator" 
      if !vote_result.nil?
        errors.add(:vote_result, "can't exist if role creator")
      elsif !accepted_invite
        errors.add(:accepted_invite, "can't be false if role creator")
      end
    end
  end

  def is_voter
    if role == "voter" && !vote_result.nil?
      if !challenge_completed
        errors.add(:vote_result, "can't vote before challenge is completed")
      elsif !accepted_invite
        errors.add(:vote_result, "can't vote if has not accepted invite to challenge")
      end   
    end
  end

end