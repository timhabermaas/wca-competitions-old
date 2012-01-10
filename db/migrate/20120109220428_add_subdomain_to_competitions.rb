class AddSubdomainToCompetitions < ActiveRecord::Migration
  def change
    add_column :competitions, :subdomain, :string, :null => false, :default => :null
  end
end
