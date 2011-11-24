class Competition < ActiveRecord::Base
  validates :name, :starts_at, :ends_at, :presence => true
  validates :name, :uniqueness => true
end
