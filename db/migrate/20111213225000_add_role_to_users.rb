class AddRoleToUsers < ActiveRecord::Migration
  def change
    add_column :users, :role, :string, :null => false, :default => "organizer"
  end
end
