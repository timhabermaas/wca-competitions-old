require "spec_helper"

describe RegistrationDay do
  describe "validations" do
    it { should validate_presence_of :registration_id }
    it { should validate_presence_of :day }

    it "cannot register for the same day twice" do
      create :registration_day, :registration_id => 1, :day => 1
      build(:registration_day, :registration_id => 1, :day => 1).should_not be_valid
      build(:registration_day, :registration_id => 1, :day => 0).should be_valid
    end
  end

  describe "scopes" do
    before :each do
      @competition = create :competition
      @pyraminx = create :event, :name => "Pyraminx"
      @schedule0 = create :schedule, :competition => @competition, :day => 0, :event => @pyraminx
      @schedule1 = create :schedule, :competition => @competition, :day => 1

      @rd0 = create :registration_day, :registration_id => 1, :day => 1 # TODO clean this up
      @rd1 = create :registration_day, :registration_id => 2, :day => 0, :schedules => [@schedule0]
      @rd2 = create :registration_day, :registration_id => 2, :day => 1, :schedules => [@schedule1]
      @rd3 = create :registration_day, :registration_id => 3, :day => 0
      @rd4 = create :registration_day, :registration_id => 3, :day => 1, :schedules => [@schedule1]
    end

    describe ".competitor" do
      it "fetches all competitors on any day" do
        RegistrationDay.competitor.should have(3).elements
        RegistrationDay.competitor.should include(@rd1)
        RegistrationDay.competitor.should include(@rd2)
        RegistrationDay.competitor.should include(@rd4)
      end
    end

    describe ".guest" do
      it "fetches all guests on any day" do
        RegistrationDay.guest.should have(2).elements
        RegistrationDay.guest.should include(@rd0)
        RegistrationDay.guest.should include(@rd3)
      end

      it "fetches all guests on day 1" do
        RegistrationDay.guest.for(1).should == [@rd0]
      end
    end
  end
end
