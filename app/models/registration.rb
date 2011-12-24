class Registration < ActiveRecord::Base
  belongs_to :participant#, :inverse_of => :registrations
  belongs_to :competition
  has_many :registration_schedules
  has_many :schedules, :through => :registration_schedules

  scope :competitor, where("id IN (SELECT registration_id FROM registrations_schedules)")

  serialize :days_as_guest

  validates :participant, :competition_id, :email, :presence => true
  validates :participant_id, :uniqueness => { :scope => :competition_id }

  accepts_nested_attributes_for :participant

  after_initialize :set_default_for_days_as_guest
  before_validation :fetch_existing_participant
  before_validation :check_for_being_guest_and_competitor, :unless => "competition.nil?"

  def days_as_guest=(days)
    write_attribute :days_as_guest, days.reject(&:blank?).map(&:to_i)
  end

  def guest?
    !days_as_guest.empty?
  end

  def guest_on?(day)
    days_as_guest.include? day
  end

  def competitor?
    !schedules.empty?
  end

  def competitor_on?(day)
    schedules.map(&:day).include? day
  end

  def days
    (schedules.map(&:day) + (days_as_guest)).uniq
  end

  def competes_in?(event)
    schedules.any? { |s| s.event_id == event.id }
  end

  private
  def fetch_existing_participant
    if participant.try(:wca_id).present?
      existing_participant = Participant.find_by_wca_id participant.wca_id
      self.participant = existing_participant unless existing_participant.nil?
    end
  end

  def check_for_being_guest_and_competitor
    competition.days.each_with_index do |day, index|
      errors.add(:days_as_guest, "can't compete and be a guest on the same day") if guest_on?(index) and competitor_on?(index)
    end
  end

  def set_default_for_days_as_guest
    self.days_as_guest ||= []
  end
end
