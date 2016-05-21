class ChangeRecordsToVotersAddUserIdToChallenges < ActiveRecord::Migration
  def change
    remove_column :records, :role
    remove_column :records, :challenge_completed

    rename_column :records, :vote_result, :vote


    rename_table :records, :voters

    add_reference :challenges, :user, index: true
  end
end
