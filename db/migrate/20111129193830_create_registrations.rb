class CreateRegistrations < ActiveRecord::Migration
  def change
    create_table :registrations do |t|
      t.integer :competition_id, :null => false
      t.integer :competitor_id, :null => false
      t.string :email, :null => false
      t.string :days
      t.timestamps
    end
  end
end
