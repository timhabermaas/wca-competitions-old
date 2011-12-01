class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.integer :event_id, :null => false
      t.integer :competition_id, :null => false
      t.time :starts_at
      t.time :ends_at
      t.integer :day, :null => false

      t.timestamps
    end
  end
end
