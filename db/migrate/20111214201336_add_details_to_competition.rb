class AddDetailsToCompetition < ActiveRecord::Migration
  def change
    add_column :competitions, :details, :text
  end
end
