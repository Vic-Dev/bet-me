class RenameIsActiveAndIsCompletedColumns < ActiveRecord::Migration
  def change
    rename_column :records, :is_completed, :challenge_completed
    rename_column :records, :is_active, :accepted_invite
  end
end
