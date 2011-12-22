class Event < ActiveRecord::Base
  attr_accessible :name, :short_name, :wca

  validates :name, :short_name, :presence => true
  validates :name, :uniqueness => true

  def official?
    wca.present?
  end
end
