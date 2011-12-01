class Schedule < ActiveRecord::Base
  belongs_to :competition
  belongs_to :event

  validates :competition_id, :event_id, :day, :starts_at, :presence => true

  validate :starts_before_it_ends
  validate :day_lies_within_competition, :unless => "competition.nil?"

  private
  def starts_before_it_ends
    unless starts_at.nil? or ends_at.nil?
      if ends_at.hour < starts_at.hour
        errors.add(:ends_at, "can't be prior to start time")
      elsif ends_at.hour == starts_at.hour
        errors.add(:ends_at, "can't be prior to start time") if ends_at.min < starts_at.min
      end
    end
  end

  def day_lies_within_competition
    errors.add(:day, "must lie within (0, #{competition.days}") unless (0..(competition.days-1)).include? day
  end
end
