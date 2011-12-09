require 'spec_helper'

describe Registration do
  before :each do
    @competition = create :competition, :starts_at => Date.new(2011, 12, 10), :ends_at => Date.new(2011, 12, 11)
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

    it "can't be registered for an event and guest on the same day" do
      reg = build :registration, :competition => @competition, :competitor => @competitor, :days_as_guest => [0], :schedules => [@schedule]
      reg.should_not be_valid
      reg.errors[:days_as_guest].should_not be_empty
    end

    it "doesn't register someone to a closed competition" # TODO or on controller level?
  end

  describe "#days" do
    it "it returns [1] if user is registered for events on day 1" do
      registration = build :registration, :competition => @competition, :competitor => @competitor, :schedules => [@schedule2]
      registration.days.should == [1]
    end

    it "returns [0, 1] if user is registered for events on day 0 and guest on day 1" do
      registration = build :registration, :competition => @competition, :competitor => @competitor, :schedules => [@schedule], :days_as_guest => [1]
      registration.days.should == [0,1]
    end

    # FIXME what about removing events?
  end

  it "fetches already saved competitor if wca_id is present" do
    competitor = build :competitor, :wca_id => "2008MUHA01"
    registration = build :registration, :competition => @competition, :competitor => competitor
    lambda {
      registration.save!
    }.should_not change(Competitor, :count)
    registration.competitor.should == @competitor
  end

  it "converts an array of strings for days_as_guest attribute to an array of integers" do
    registration = build :registration, :days_as_guest => ["1", "2"]
    registration.days_as_guest.should == [1, 2]
  end

  describe "guest" do
    it "days_as_guest should be an empty array after initialization" do
      Registration.new.days_as_guest.should == []
    end

    it "is guest if the competitor is guest on at least one day" do
      registration = Registration.new
      registration.should_not be_guest
      registration.days_as_guest << 0
      registration.should be_guest
    end

    it "is guest on day 0 if days_as_guest contains 0" do
      registration = Registration.new :days_as_guest => [2, 0]
      registration.guest_on?(0).should == true
      registration.guest_on?(1).should == false
    end
  end

  describe "competitor" do
    it "is competitor on day 0 if he's registered for at least one event on day 0" do
      registration = Registration.new :schedules => [@schedule]
      registration.competitor_on?(0).should == true
      registration.competitor_on?(1).should == false
    end

    it "is competitor if the competitor is competitor on at least one day" do
      registration = Registration.new
      registration.should_not be_competitor
      registration.schedules << @schedule
      registration.should be_competitor
    end
  end
end
