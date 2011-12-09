class AddClosedToCompetitions < ActiveRecord::Migration
  def change
    add_column :competitions, :closed, :boolean, :null => false, :default => false
  end
end
