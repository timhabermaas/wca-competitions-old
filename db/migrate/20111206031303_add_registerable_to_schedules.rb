class AddRegisterableToSchedules < ActiveRecord::Migration
  def change
    add_column :schedules, :registerable, :boolean, :null => false, :default => false
  end
end
