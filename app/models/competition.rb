class Competition < ActiveRecord::Base
  attr_accessible :name, :starts_at, :ends_at, :details, :closed

  has_many :news, :order => "created_at desc"
  has_many :registrations
  has_many :competitors, :through => :registrations
  has_many :schedules do
    def for(day)
      where("schedules.day" => day)
    end
  end
  has_many :events, :through => :schedules, :uniq => true
  belongs_to :user

  validates :name, :starts_at, :ends_at, :user_id, :presence => true
  validates :name, :uniqueness => true
  validate :starts_before_it_ends

  def days
    starts_at..ends_at
  end

  def day_indices
    (0..(ends_at - starts_at).to_i)
  end

  private
  def starts_before_it_ends
    unless starts_at.nil? or ends_at.nil?
      errors.add(:ends_at, "can't be prior to start date") if ends_at < starts_at
    end
  end
end
