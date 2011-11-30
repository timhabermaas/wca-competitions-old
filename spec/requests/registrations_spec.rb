#encoding: utf-8

require "spec_helper"

describe "Registrations" do
  before :each do
    @competition = create :competition, :name => "Munich Open 2011"
    @dieter = create :competitor, :first_name => "Dieter", :last_name => "Müller", :wca_id => "2008MULL01"
    @peter = create :competitor, :first_name => "Peter", :last_name => "Müller"
    @registraion = Registration.create :competition => @competition, :competitor => @dieter, :email => "muh@cow.com"
    @registraion = Registration.create :competition => @competition, :competitor => @peter, :email => "muh2@cow.com"
  end

  describe "GET /registrations" do
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

    it "doesn't create a new competitor if his WCA ID already exists"
  end
end
