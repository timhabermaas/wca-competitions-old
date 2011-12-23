class Schedule < ActiveRecord::Base
  belongs_to :competition
  belongs_to :event

  delegate :name, :to => :event

  scope :registerable, where(:registerable => true)

  validates :competition_id, :event_id, :day, :starts_at, :presence => true

  validate :starts_before_it_ends
  validate :day_lies_within_competition, :unless => "competition.nil?"

  before_validation :fix_time_objects

  private
  def starts_before_it_ends
    unless starts_at.nil? or ends_at.nil?
      errors.add(:ends_at, "can't be prior to start time") if ends_at < starts_at
    end
  end

  def day_lies_within_competition
    errors.add(:day, "must lie within (0, #{competition.days}") unless (0..(competition.days.to_a.size - 1)).include? day
  end

  def fix_time_objects
    self.starts_at = starts_at.try(:change, :year => 2000, :month => 1, :day => 1)
    self.ends_at = ends_at.try(:change, :year => 2000, :month => 1, :day => 1)
  end
end
