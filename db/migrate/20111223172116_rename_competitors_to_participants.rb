class RenameCompetitorsToParticipants < ActiveRecord::Migration
  def change
    rename_table :competitors, :participants
    rename_column :registrations, :competitor_id, :participant_id
  end
end
