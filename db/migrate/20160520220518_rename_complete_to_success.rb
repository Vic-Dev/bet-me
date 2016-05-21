class RenameCompleteToSuccess < ActiveRecord::Migration
  def change
    add_column :challenges, :complete, :boolean
    add_column :challenges, :successful, :boolean
  end
end
