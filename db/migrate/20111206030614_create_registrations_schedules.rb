class CreateRegistrationsSchedules < ActiveRecord::Migration
  def up
    create_table :registrations_schedules do |t|
      t.integer :schedule_id, :null => false
      t.integer :registration_id, :null => false
      t.timestamps
    end
    drop_table :events_registrations
  end

  def down
    create_table :events_registrations do |t|
      t.integer :event_id, :null => false
      t.integer :registration_id, :null => false
      t.timestamps
    end
    drop_table :registrations_schedules
  end
end
