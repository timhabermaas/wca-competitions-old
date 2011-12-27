class Participant < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :wca_id, :gender, :date_of_birth

  has_many :registrations
  has_many :competitions, :through => :registrations

  validates :first_name, :last_name, :date_of_birth, :gender, :presence => true
  validates :wca_id, :uniqueness => true
  validates :gender, :inclusion => %w(m f)

  before_save :set_wca_id_to_nil, :if => "wca_id.blank?"

  def full_name
    first_name + " " + last_name
  end

  def fastest_average_for(event)
    WCA::Result.find(:first, :params => { :person_id => wca_id, :event_id => event.wca, :best => "average" }).try(:average) # TODO: move to WCA::Result
  end

  def fastest_single_for(event)
    WCA::Result.find(:first, :params => { :person_id => wca_id, :event_id => event.wca, :best => "single" }).try(:best)
  end

  private
  def set_wca_id_to_nil # FIXME: there must be a nicer solution...
    self.wca_id = nil
  end
end
