class CreateEventsRegistrations < ActiveRecord::Migration
  def change
    create_table :events_registrations do |t|
      t.integer :event_id, :null => false
      t.integer :registration_id, :null => false
      t.timestamps
    end
  end
end
