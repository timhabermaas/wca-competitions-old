class RegistrationSchedule < ActiveRecord::Base
  set_table_name "registrations_schedules"

  belongs_to :schedule
  belongs_to :registration

  validates_uniqueness_of :schedule_id, :scope => :registration_id
end
