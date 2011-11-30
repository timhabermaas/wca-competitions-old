require 'spec_helper'

describe Registration do
  describe "validations" do
    it { should validate_presence_of :competition_id }
    it { should validate_presence_of :competitor }
    it { should validate_presence_of :email }

    it "prevents a competitor from participating in the same competition twice" do
      competition = create :competition
      competitor = create :competitor
      create :registration, :competition => competition, :competitor => competitor
      reg = build :registration, :competition_id => competition.id, :competitor_id => competitor.id
      reg.should_not be_valid
      reg.errors[:competitor_id].should_not be_empty
    end
  end
end
