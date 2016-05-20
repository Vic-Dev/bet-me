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



  def creator
    record = Record.where("challenge_id = ? AND role = ?",self.id , "creator").first
    raise "Record does not have a creator! This is really broken!" unless record
    User.find(record.user_id)
  end

  def voter
    record = Record.where("challenge_id = ? AND role = ?",self.id , "voter").first
    raise "Record does not have a creator! This is really broken!" unless record
    User.find(record.user_id)
  end

end
