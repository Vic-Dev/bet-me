class AddRecords < ActiveRecord::Migration
  def change
    create_table :records do |t|
      t.integer :challenge_id
      t.integer :user_id
      t.string :role
      t.boolean :is_active
      t.boolean :is_completed
      t.boolean :vote_result
    end
  end
end
