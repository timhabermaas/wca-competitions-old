class CreateCompetitions < ActiveRecord::Migration
  def change
    create_table :competitions do |t|
      t.string :name, :null => false
      t.datetime :starts_at, :null => false
      t.datetime :ends_at, :null => false

      t.timestamps
    end
  end
end
