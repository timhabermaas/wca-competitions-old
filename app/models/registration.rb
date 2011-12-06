class Registration < ActiveRecord::Base
  belongs_to :competitor#, :inverse_of => :registrations
  belongs_to :competition
  has_many :registration_schedules
  has_many :schedules, :through => :registration_schedules

  serialize :days

  validates :competitor, :competition_id, :email, :presence => true
  validates :competitor_id, :uniqueness => { :scope => :competition_id }

  accepts_nested_attributes_for :competitor

  before_validation :fetch_competitor

  def days=(days)
    write_attribute :days, days.map(&:to_i)
  end

  def guest?
    schedules.empty?
  end

  def guest_on?(day)
    !schedules.any? { |s| s.day == day }
  end

  private
  def fetch_competitor
    if competitor.try(:wca_id).present?
      existing_competitor = Competitor.find_by_wca_id competitor.wca_id
      self.competitor = existing_competitor unless existing_competitor.nil?
    end
  end
end
