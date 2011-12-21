class News < ActiveRecord::Base
  attr_accessible :content

  belongs_to :competition
  belongs_to :user

  translates :content

  validates :content, :competition_id, :user_id, :presence => true
end
