class RenameRegistrationIdToRegistrationDayId < ActiveRecord::Migration
  def change
    rename_column :registrations_schedules, :registration_id, :registration_day_id
    rename_table :registrations_schedules, :registration_days_schedules
  end
end
