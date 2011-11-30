class Registration < ActiveRecord::Base
  belongs_to :competitor#, :inverse_of => :registrations
  belongs_to :competition

  validates :competitor, :competition_id, :email, :presence => true
  validates :competitor_id, :uniqueness => { :scope => :competition_id }

  accepts_nested_attributes_for :competitor
end
