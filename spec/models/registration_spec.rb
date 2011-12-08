require 'spec_helper'

describe Registration do
  before :each do
    @competition = create :competition
    @competitor = create :competitor, :wca_id => "2008MUHA01"
    @schedule = create :schedule, :competition => @competition, :day => 0
    @schedule2 = create :schedule, :competition => @competition, :day => 1
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

    describe "#days" do
      it "it sets days to [1] if user is registered for events on day 1" do
        registration = create :registration, :competition => @competition, :competitor => @competitor, :schedules => [@schedule2]
        registration.days.should == [1]
      end

      it "keeps existing days entries" do
        registration = create :registration, :competition => @competition, :competitor => @competitor, :schedules => [@schedule2], :days => [0]
        registration.days.should include(0)
        registration.days.should include(1)
      end

      # FIXME what about removing events?
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

  it "is guest if the competitor doesn't compete in any events" do
    registration = build :registration, :days => [0, 1], :schedules => [@schedule]
    registration.should_not be_guest
    registration.schedules = []
    registration.should be_guest
  end

  it "is guest on day 0, if he doesn't compete in anything on day 0" do
    registration = build :registration, :days => [0, 1], :schedules => [@schedule2]
    registration.guest_on?(0).should be_true
    registration.guest_on?(1).should be_false
  end
end
