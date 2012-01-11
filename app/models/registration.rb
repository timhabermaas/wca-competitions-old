class Registration < ActiveRecord::Base
  belongs_to :participant
  belongs_to :competition
  has_many :registration_days, :inverse_of => :registration, :order => "day"
  has_many :registration_day_schedules, :through => :registration_days
  has_many :schedules, :through => :registration_day_schedules

  scope :competitors, where("EXISTS
                            (SELECT * FROM registration_days WHERE registration_days.registration_id = registrations.id
                            AND registration_days.id IN (SELECT registration_day_id FROM registration_days_schedules))").
                            includes(:participant, :schedules)
  scope :guests, where("NOT EXISTS
                       (SELECT * FROM registration_days WHERE registration_days.registration_id = registrations.id
                       AND registration_days.id IN (SELECT registration_day_id FROM registration_days_schedules))").
                       includes(:participant, :schedules)
  scope :for_day, lambda { |day| joins(:registration_days).where("registration_days.day" => day) }
  scope :for_event, lambda { |event| joins(:schedules).where("schedules.event_id" => event.id) }
  scope :with_wca_id, joins(:participant).where("participants.wca_id IS NOT NULL")

  validates :participant, :competition_id, :email, :presence => true
  validates :participant_id, :uniqueness => { :scope => :competition_id }
  validates :comment, :length => { :maximum => 1000 }
  validate :registered_for_at_least_one_day

  accepts_nested_attributes_for :participant
  accepts_nested_attributes_for :registration_days, :reject_if => lambda { |a| a[:day].blank? }, :allow_destroy => true

  before_validation :fetch_existing_participant

  delegate :full_name, :gender, :wca_id, :country, :age, :to => :participant

  def competitor_on?(day)
    schedules.map(&:day).include? day
  end

  def guest_on?(day)
    registration_days.map(&:day).include? day
  end

  def competes_in?(event)
    s = registration_days.map do |r|
      r.schedules
    end.flatten # FIXME nested has_many through fail?
    s.any? { |s| s.event_id == event.id }
  end

  private
  def fetch_existing_participant
    if participant.try(:wca_id).present?
      existing_participant = Participant.find_by_wca_id participant.wca_id
      self.participant = existing_participant unless existing_participant.nil?
    end
  end

  def registered_for_at_least_one_day
    errors.add(:registration_days, "can't be empty") if registration_days.empty?
  end
end
