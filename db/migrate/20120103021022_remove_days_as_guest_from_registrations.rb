class RemoveDaysAsGuestFromRegistrations < ActiveRecord::Migration
  def up
    remove_column :registrations, :days_as_guest
  end

  def down
    add_column :registrations, :days_as_guest, :string
  end
end
