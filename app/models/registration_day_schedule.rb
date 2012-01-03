class RegistrationDaySchedule < ActiveRecord::Base
  set_table_name "registration_days_schedules"

  belongs_to :schedule
  belongs_to :registration_day

  validates_uniqueness_of :schedule_id, :scope => :registration_day_id
end
