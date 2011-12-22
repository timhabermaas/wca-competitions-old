class AddShortNameToEvents < ActiveRecord::Migration
  def change
    add_column :events, :short_name, :string, :null => false, :default => ""
  end
end
