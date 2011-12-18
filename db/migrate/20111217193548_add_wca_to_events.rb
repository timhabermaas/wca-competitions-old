class AddWcaToEvents < ActiveRecord::Migration
  def change
    add_column :events, :wca, :string
  end
end
