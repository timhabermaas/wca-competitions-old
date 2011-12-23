class AddAddressToCompetitions < ActiveRecord::Migration
  def change
    add_column :competitions, :address, :text
  end
end
