class Competition < ActiveRecord::Base
  has_many :news

  validates :name, :starts_at, :ends_at, :presence => true
  validates :name, :uniqueness => true
end
