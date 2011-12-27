class Event < ActiveRecord::Base
  attr_accessible :name, :short_name, :wca

  validates :name, :short_name, :presence => true
  validates :name, :uniqueness => true

  scope :official, where("wca IS NOT NULL")

  before_save :set_wca_to_nil, :if => "wca.blank?"

  private
  def set_wca_to_nil # TODO ARGH..., extract common behavior?
    self.wca = nil
  end
end
