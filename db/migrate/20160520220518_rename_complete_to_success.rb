class RenameCompleteToSuccess < ActiveRecord::Migration
  def change
    add_column :challenges, :successful, :boolean
    add_column :challenges, :complete, :boolean, default: false
  end
end
