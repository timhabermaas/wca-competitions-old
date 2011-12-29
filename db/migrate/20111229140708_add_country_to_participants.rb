class AddCountryToParticipants < ActiveRecord::Migration
  def change
    add_column :participants, :country, :string
  end
end
