#encoding: utf-8

require "spec_helper"

describe "Registrations" do
  before :each do
    @competition = create :competition, :name => "Munich Open 2011"
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
    it "registers Peter at the Competition" do
      visit new_competition_registration_path(@competition)
      fill_in "First name", :with => "Peter"
      fill_in "Last name", :with => "Mustermann"
      fill_in "Email", :with => "peter@mustermann.de"
      click_on "Register"
      page.should have_content("Successfully registered")
      page.should have_content("Peter Mustermann")
    end

    it "doesn't create a new competitor if his WCA ID already exists" do
      create :competitor, :first_name => "Dieter", :last_name => "Müller", :wca_id => "2008MULL01"
      visit new_competition_registration_path(@competition)
      fill_in "First name", :with => "Dieter"
      fill_in "Last name", :with => "Müller"
      fill_in "Email", :with => "peter@mustermann.de"
      fill_in "WCA ID", :with => "2008MULL01"
      click_on "Register"
      page.should have_content("Successfully registered")
      page.should have_content("Dieter Müller")
      Competitor.count.should == 1
    end
  end
end
