require 'spec_helper'

describe Registration do
  before :each do
    Participant.any_instance.stub(:country_is_existent) # TODO find a decent way for this
    Participant.any_instance.stub(:wca_id_is_existent)
    @competition = create :competition, :starts_at => Date.new(2011, 12, 10), :ends_at => Date.new(2011, 12, 11)
    @participant = create :participant, :wca_id => "2008MUHA01"
    @pyraminx = create :event, :name => "Pyraminx"
    @schedule0 = create :schedule, :competition => @competition, :day => 0, :event => @pyraminx
    @schedule1 = create :schedule, :competition => @competition, :day => 1
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

    it "must be registered for at least one day" do
      reg = build(:registration, :registration_days => [])
      reg.should_not be_valid
      reg.errors[:registration_days].should_not be_empty
    end

    it "keeps the comment under 1000 characters" do
      reg = Registration.new(:comment => "m" * 1001)
      reg.should_not be_valid
      reg.errors[:comment].should_not be_empty
    end
  end

  describe "scopes" do
    before :each do
      @r1 = create_registration :competition => @competition, :guest_days => [0]
      @r2 = create_registration :competition => @competition, :schedules => [@schedule0, @schedule1]
      @r3 = create_registration :competition => @competition, :guest_days => [0], :schedules => [@schedule1]
    end

    describe ".competitors" do
      it "fetches all cubers and no guests" do
        Registration.competitors.should have(2).elements
        Registration.competitors.should include(@r2)
        Registration.competitors.should include(@r3)
      end

      it "must be chainable" do
        Registration.competitors.where(:competition_id => @competition.id).should include(@r2)
      end
    end

    describe ".guests" do
      it "fetches guests and no cubers" do
        Registration.guests.should have(1).elements
        Registration.guests.should include(@r1)
      end

      it "must be chainable" do
        Registration.guests.where(:competition_id => @competition.id).should include(@r1)
      end
    end

    describe ".for_event" do
      it "finds all registrations for Pyraminx" do
        Registration.for_event(@pyraminx).should == [@r2]
      end
    end

    describe ".for_day" do
      it "finds all registrations for day 0" do
        Registration.for_day(0).should have(3).elements
        Registration.for_day(0).should include(@r1)
        Registration.for_day(0).should include(@r2)
        Registration.for_day(0).should include(@r3)
      end

      it "finds all registrations for day 1" do
        Registration.for_day(1).should have(2).elements
        Registration.for_day(1).should include(@r2)
        Registration.for_day(1).should include(@r3)
      end
    end

    describe ".with_wca_id" do
      it "finds all people with WCA ID" do
        r = create :registration, :participant => build(:participant_with_wca_id)
        Registration.with_wca_id.should == [r]
      end
    end

    describe ".without_wca_id" do
      it "finds all people without WCA ID" do
        r = create :registration, :participant => build(:participant_with_wca_id)
        Registration.without_wca_id.should_not include(r)
        Registration.without_wca_id.count.should == 3 # TODO clean up setup
      end
    end
  end

  describe "#competes_in?" do
    it "returns true if the participant has registered for the event" do
      rd = create :registration_day, :schedules => [@schedule0]
      registration = create :registration, :registration_days => [rd]
      registration.competes_in?(@schedule0.event).should == true
      registration.competes_in?(@schedule1.event).should == false
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

  describe "#competitor_on?" do
    it "is competitor on day 0 if he's registered for at least one event on day 0" do
      registration = Registration.new :schedules => [@schedule0]
      registration.competitor_on?(0).should == true
      registration.competitor_on?(1).should == false
    end
  end

  describe "#guest_on?" do
    it "is guest on day 0 if he's not registered for any event on day 0, but will come anyway" do
      registration = Registration.new :schedules => [], :registration_days => [RegistrationDay.new(:day => 0)]
      registration.guest_on?(0).should == true
      registration.guest_on?(1).should == false
    end
  end
end
