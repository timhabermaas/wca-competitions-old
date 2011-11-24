class News < ActiveRecord::Base
  belongs_to :competition
  validates :content, :competition_id, :presence => true
end
