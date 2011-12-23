require 'spec_helper'

describe Registration do
  before :each do
    @competition = create :competition, :starts_at => Date.new(2011, 12, 10), :ends_at => Date.new(2011, 12, 11)
    @participant = create :participant, :wca_id => "2008MUHA01"
    @schedule = create :schedule, :competition => @competition, :day => 0
    @schedule2 = create :schedule, :competition => @competition, :day => 1
  end

  describe "validations" do
    it { should validate_presence_of :competition_id }
    it { should validate_presence_of :participant }
    it { should validate_presence_of :email }

    it "prevents a participant from participating in the same competition twice" do
      create :registration, :competition => @competition, :participant => @participant
      reg = build :registration, :competition_id => @competition.id, :participant_id => @participant.id
      reg.should_not be_valid
      reg.errors[:participant_id].should_not be_empty
    end

    it "can't be registered for an event and guest on the same day" do
      reg = build :registration, :competition => @competition, :participant => @participant, :days_as_guest => [0], :schedules => [@schedule]
      reg.should_not be_valid
      reg.errors[:days_as_guest].should_not be_empty
    end
  end

  describe "#days" do
    it "it returns [1] if user is registered for events on day 1" do
      registration = build :registration, :competition => @competition, :participant => @participant, :schedules => [@schedule2]
      registration.days.should == [1]
    end

    it "returns [0, 1] if user is registered for events on day 0 and guest on day 1" do
      registration = build :registration, :competition => @competition, :participant => @participant, :schedules => [@schedule], :days_as_guest => [1]
      registration.days.should == [0,1]
    end

    # FIXME what about removing events?
  end

  describe "#competes_in?" do
    it "returns true if the participant has registered for the event" do
      registration = create :registration, :schedules => [@schedule]
      registration.competes_in?(@schedule.event).should == true
      registration.competes_in?(@schedule2.event).should == false
    end
  end

  it "fetches already saved participant if wca_id is present" do
    participant = build :participant, :wca_id => "2008MUHA01"
    registration = build :registration, :competition => @competition, :participant => participant
    lambda {
      registration.save!
    }.should_not change(Participant, :count)
    registration.participant.should == @participant
  end

  it "converts an array of strings for days_as_guest attribute to an array of integers" do
    registration = build :registration, :days_as_guest => ["1", "2"]
    registration.days_as_guest.should == [1, 2]
  end

  describe "days_as_guest" do
    it "is an empty array after initialization" do
      Registration.new.days_as_guest.should == []
    end

    it "accepts stuff like ['', '0', ''] and makes it [0]" do
      Registration.new(:days_as_guest => ["", "0", ""]).days_as_guest.should == [0]
    end
  end

  describe "guest" do
    it "is guest if the participant is guest on at least one day" do
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

    it "is competitor if the participant is competitor on at least one day" do
      registration = Registration.new
      registration.should_not be_competitor
      registration.schedules << @schedule
      registration.should be_competitor
    end
  end
end
