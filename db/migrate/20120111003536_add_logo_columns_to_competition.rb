class AddLogoColumnsToCompetition < ActiveRecord::Migration
  def self.up
    change_table :competitions do |t|
      t.has_attached_file :logo
    end
  end

  def self.down
    drop_attached_file :competitions, :logo
  end
end
