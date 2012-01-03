class RegistrationDay < ActiveRecord::Base
  belongs_to :registration, :inverse_of => :registration_days
  has_many :registration_day_schedules
  has_many :schedules, :through => :registration_day_schedules

  scope :competitor, where("registration_days.id IN (SELECT registration_day_id FROM registration_days_schedules)")
  scope :guest, where("registration_days.id NOT IN (SELECT registration_day_id FROM registration_days_schedules)")

  scope :for, lambda { |d| where(:day => d) }

  validates_presence_of :day
  validates_presence_of :registration_id, :unless => lambda { registration.present? }
  validates_uniqueness_of :registration_id, :scope => :day
end
