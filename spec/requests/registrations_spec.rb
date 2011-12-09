#encoding: utf-8

require "spec_helper"

describe "Registrations" do
  before :each do
    @competition = create :competition, :name => "Munich Open 2011", :starts_at => Date.new(2011, 11, 26), :ends_at => Date.new(2011, 11, 27)
    @three = create :event, :name => "3x3x3"
    @four = create :event, :name => "4x4x4"
    @pyraminx = create :event, :name => "Pyraminx"
    @megaminx = create :event, :name => "Megaminx"
  end

  describe "GET /registrations" do
    before :each do
      @dieter = create :competitor, :first_name => "Dieter", :last_name => "Müller", :wca_id => "2008MULL01"
      @peter = create :competitor, :first_name => "Peter", :last_name => "Müller"
      @registraion = Registration.create :competition => @competition, :competitor => @dieter, :email => "muh@cow.com"
      @registraion = Registration.create :competition => @competition, :competitor => @peter, :email => "muh2@cow.com"
    end

    it "lists all registered competitors for Munich Open" do
      visit competition_registrations_path(@competition)
      page.should have_link("Dieter Müller", :href => "http://worldcubeassociation.org/results/p.php?i=2008MULL01")
      page.should have_content("Peter Müller")
      page.should_not have_link("Peter Müller") # TODO what about linking to a competitors page instead of linking to the WCA profile?
    end
  end

  describe "POST /registrations" do
    before :each do
      @s1 = create :schedule, :event => @three, :competition => @competition, :day => 0, :registerable => true
      @s2 = create :schedule, :event => @four, :competition => @competition, :day => 0, :registerable => true
      @s3 = create :schedule, :event => @pyraminx, :competition => @competition, :day => 1, :registerable => true
      @s4 = create :schedule, :event => @megaminx, :competition => @competition, :day => 1, :registerable => true
      @lunch = create :schedule, :competition => @competition, :day => 1, :registerable => false
    end

    def fill_in_with_peter
      fill_in "First name", :with => "Peter"
      fill_in "Last name", :with => "Mustermann"
      choose("male")
      fill_in "Email", :with => "peter@mustermann.de"
    end

    it "registers Peter at the Competition" do
      visit new_competition_registration_path(@competition)
      fill_in_with_peter
      click_on "Register"
      page.should have_content("Successfully registered")
      page.should have_content("Peter Mustermann")
    end

    it "doesn't create a new competitor if his WCA ID already exists" do
      create :competitor, :first_name => "Peter", :last_name => "Mustermann", :wca_id => "2008MUST01"
      visit new_competition_registration_path(@competition)
      fill_in_with_peter
      fill_in "WCA ID", :with => "2008MUST01"
      click_on "Register"
      page.should have_content("Successfully registered")
      page.should have_content("Peter Mustermann")
      Competitor.count.should == 1
    end

    it "registers Peter for 3x3x3 and 4x4x4" do
      visit new_competition_registration_path(@competition)
      fill_in_with_peter
      within(".day0") do
        check "3x3x3"
        check "4x4x4"
      end
      within(".day1") do
        check "Pyraminx"
      end
      click_on "Register"
      page.should have_content("Peter Mustermann")

      @competition.registrations.first.schedules.should include(@s1)
      @competition.registrations.first.schedules.should include(@s2)
      @competition.registrations.first.schedules.should include(@s3)
      @competition.registrations.first.schedules.should_not include(@s4)
    end

    it "registers Peter for Sunday only" do
      visit new_competition_registration_path(@competition)

      fill_in_with_peter
      check "Guest on Sunday"
      click_on "Register"

      page.should have_content("Peter Mustermann")
      @competition.registrations.first.days_as_guest.should == [1]
      @competition.registrations.first.should be_guest
    end

    it "doesn't show events which aren't available for registration" do
      visit new_competition_registration_path(@competition)

      page.should_not have_content(@lunch.event.name)
    end
  end
end
