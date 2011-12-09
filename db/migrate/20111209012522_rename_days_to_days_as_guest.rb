class RenameDaysToDaysAsGuest < ActiveRecord::Migration
  def up
    rename_column :registrations, :days, :days_as_guest
  end

  def down
    rename_column :registrations, :days_as_guest, :days
  end
end
