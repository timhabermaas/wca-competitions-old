class ChangeDefaultForUsersRoleToUser < ActiveRecord::Migration
  def up
    change_column :users, :role, :string, :null => false, :default => "user"
  end

  def down
    change_column :users, :role, :string, :null => false, :default => "organizer"
  end
end
