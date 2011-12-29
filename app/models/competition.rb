class Competition < ActiveRecord::Base
  attr_accessible :name, :starts_at, :ends_at, :address, :details, :closed

  has_many :news, :order => "created_at desc"
  has_many :registrations
  has_many :participants, :through => :registrations
  has_many :schedules do
    def for(day)
      where("schedules.day" => day)
    end
  end
  has_many :events, :through => :schedules, :uniq => true, :order => "schedules.day, schedules.starts_at" do
    def registerable
      where("schedules.registerable" => true) # FIXME: duplicated code
    end
  end
  belongs_to :user

  validates :name, :starts_at, :ends_at, :user_id, :presence => true
  validates :name, :uniqueness => true
  validate :starts_before_it_ends

  def days
    starts_at..ends_at
  end

  def amount_of_days
    (ends_at - starts_at).to_i + 1
  end

  def compare_competitors_for(event) # TODO test
    registrations.with_wca_id.for_event(event).includes(:participant).map do |r| # TODO move to model
      single = r.participant.fastest_single_for event
      next if single.nil?
      average = r.participant.fastest_average_for event
      { :participant => r.participant, :single => single, :average => average }
    end.compact.sort_by { |r| [r[:average] || 8_640_000, r[:single]] } # FIXME remove random 24h number
  end

  private
  def starts_before_it_ends
    unless starts_at.nil? or ends_at.nil?
      errors.add(:ends_at, "can't be prior to start date") if ends_at < starts_at
    end
  end
end
