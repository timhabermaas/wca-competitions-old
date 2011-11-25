class CreateCompetitions < ActiveRecord::Migration
  def change
    create_table :competitions do |t|
      t.string :name, :null => false
      t.date :starts_at, :null => false
      t.date :ends_at, :null => false
      t.integer :user_id, :null => false
      t.timestamps
    end
  end
end
