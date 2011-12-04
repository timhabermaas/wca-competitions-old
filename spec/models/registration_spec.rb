require 'spec_helper'

describe Registration do
  before :each do
    @competition = create :competition
    @competitor = create :competitor, :wca_id => "2008MUHA01"
  end

  describe "validations" do
    it { should validate_presence_of :competition_id }
    it { should validate_presence_of :competitor }
    it { should validate_presence_of :email }

    it "prevents a competitor from participating in the same competition twice" do
      create :registration, :competition => @competition, :competitor => @competitor
      reg = build :registration, :competition_id => @competition.id, :competitor_id => @competitor.id
      reg.should_not be_valid
      reg.errors[:competitor_id].should_not be_empty
    end
  end

  it "fetches already saved competitor if wca_id is present" do
    competitor = build :competitor, :wca_id => "2008MUHA01"
    registration = build :registration, :competition => @competition, :competitor => competitor
    lambda {
      registration.save!
    }.should_not change(Competitor, :count)
    registration.competitor.should == @competitor
  end

  it "converts an array of strings for days attribute to an array of integers" do
    registration = build :registration, :days => ["1", "2"]
    registration.days.should == [1, 2]
  end
end
