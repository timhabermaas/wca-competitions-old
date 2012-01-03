class Participant < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :wca_id, :gender, :country, :date_of_birth

  has_many :registrations
  has_many :competitions, :through => :registrations

  validates :first_name, :last_name, :date_of_birth, :gender, :country, :presence => true
  validates :wca_id, :uniqueness => { :allow_nil => true }
  validates :gender, :inclusion => %w(m f)
  validate :wca_id_is_existent, :unless => "wca_id.blank?"
  validate :country_is_existent, :unless => "country.blank?"

  after_initialize :set_wca_id_to_nil, :if => "wca_id.blank?"

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

  def wca_id_is_existent
    begin
      WCA::Person.find(wca_id)
    rescue ActiveResource::ResourceNotFound
      errors.add(:wca_id, "doesn't exist")
    end
  end

  def country_is_existent
    errors.add(:country, "is not an official country") unless WCA::Country.find(:all).any? { |c| c.name == country }
  end
end
