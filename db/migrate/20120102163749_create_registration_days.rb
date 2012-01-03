class CreateRegistrationDays < ActiveRecord::Migration
  def change
    create_table :registration_days do |t|
      t.integer :registration_id, :null => false
      t.integer :day, :null => false

      t.timestamps
    end
  end
end
