class AddChallenges < ActiveRecord::Migration
  def change
    create_table :challenges do |t|
      t.string :title
      t.string :description
      t.decimal :wager
      t.datetime :start_time
      t.datetime :end_time
    end
  end
end
