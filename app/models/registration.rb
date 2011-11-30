class Registration < ActiveRecord::Base
  belongs_to :competitor#, :inverse_of => :registrations
  belongs_to :competition

  validates :competitor, :competition_id, :email, :presence => true
  validates :competitor_id, :uniqueness => { :scope => :competition_id }

  accepts_nested_attributes_for :competitor

  before_validation :fetch_competitor

  private
  def fetch_competitor
    if competitor.try(:wca_id).present?
      existing_competitor = Competitor.find_by_wca_id competitor.wca_id
      self.competitor = existing_competitor unless existing_competitor.nil?
    end
  end
end
