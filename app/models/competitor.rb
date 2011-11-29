class Competitor < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :wca_id, :gender

  validates :first_name, :last_name, :presence => true
  validates :wca_id, :uniqueness => true
  validates :gender, :inclusion => %w(m w)
end
