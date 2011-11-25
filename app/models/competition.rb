class Competition < ActiveRecord::Base
  attr_accessible :name, :starts_at, :ends_at

  has_many :news
  belongs_to :user

  validates :name, :starts_at, :ends_at, :user_id, :presence => true
  validates :name, :uniqueness => true
  validate :cannot_end_before_it_started

  private
  def cannot_end_before_it_started
    unless starts_at.nil? or ends_at.nil?
      errors.add(:ends_at, "can't be prior to start date") if ends_at < starts_at
    end
  end
end
