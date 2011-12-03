class Competitor < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :wca_id, :gender, :date_of_birth

  has_many :registrations
  has_many :competitions, :through => :registrations

  validates :first_name, :last_name, :date_of_birth, :presence => true
  validates :wca_id, :uniqueness => true
  validates :gender, :inclusion => %w(m f)

  def full_name
    first_name + " " + last_name
  end
end