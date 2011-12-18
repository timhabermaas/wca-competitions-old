class Event < ActiveRecord::Base
  attr_accessible :name, :wca

  validates :name, :presence => true
  validates :name, :uniqueness => true
end
