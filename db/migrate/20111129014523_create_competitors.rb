class CreateCompetitors < ActiveRecord::Migration
  def change
    create_table :competitors do |t|
      t.string :first_name, :null => false
      t.string :last_name
      t.string :wca_id
      t.date :date_of_birth, :null => false
      t.string :gender, :null => false
      t.timestamps
    end
  end
end
