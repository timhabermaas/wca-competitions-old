class Registration < ActiveRecord::Base
  belongs_to :competitor#, :inverse_of => :registrations
  belongs_to :competition
  has_many :registration_schedules
  has_many :schedules, :through => :registration_schedules

  serialize :days_as_guest

  validates :competitor, :competition_id, :email, :presence => true
  validates :competitor_id, :uniqueness => { :scope => :competition_id }

  accepts_nested_attributes_for :competitor

  after_initialize :set_default_for_days_as_guest
  before_validation :fetch_existing_competitor
  before_validation :check_for_being_guest_and_competitor, :unless => "competition.nil?"

  def days_as_guest=(days)
    write_attribute :days_as_guest, days.map(&:to_i)
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

  private
  def fetch_existing_competitor
    if competitor.try(:wca_id).present?
      existing_competitor = Competitor.find_by_wca_id competitor.wca_id
      self.competitor = existing_competitor unless existing_competitor.nil?
    end
  end

  def check_for_being_guest_and_competitor
    competition.day_indices.each do |day|
      errors.add(:days_as_guest, "can't compete and be a guest on the same day") if guest_on?(day) and competitor_on?(day)
    end
  end

  def set_default_for_days_as_guest
    self.days_as_guest ||= []
  end
end
