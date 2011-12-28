#encoding: utf-8

require "spec_helper"

describe "Registrations" do
  before :each do
    WCA::Person.stub!(:find).and_return(nil) # FIXME disable wca_id validation for these tests in a nicer way
    @competition = create :competition, :name => "Munich Open 2011", :starts_at => Date.new(2011, 11, 26), :ends_at => Date.new(2011, 11, 27)
    @three = create :event, :name => "3x3x3", :wca => "333"
    @four = create :event, :name => "4x4x4", :wca => "444"
    @four_bld = create :event, :name => "4x4x4 BLD", :wca => "444bf"
    @pyraminx = create :event, :name => "Pyraminx", :wca => "pyram"
    @megaminx = create :event, :name => "Megaminx", :wca => "minx"
    @schedule_3 = create :schedule, :event => @three, :competition => @competition, :day => 0, :registerable => true
    @schedule_4 = create :schedule, :event => @four, :competition => @competition, :day => 0, :registerable => true
    @schedule_4bf = create :schedule, :event => @four_bld, :competition => @competition, :day => 1, :registerable => true
    @schedule_py = create :schedule, :event => @pyraminx, :competition => @competition, :day => 1, :registerable => true
    @schedule_mx = create :schedule, :event => @megaminx, :competition => @competition, :day => 1, :registerable => true
  end

  describe "GET /registrations" do
    before :each do
      @dieter = create :participant, :first_name => "Dieter", :last_name => "Müller", :wca_id => "2008MULL01"
      @peter = create :participant, :first_name => "Peter", :last_name => "Müller"
      create :registration, :competition => @competition, :participant => @dieter, :schedules => [@schedule_3], :email => "muh@cow.com"
      create :registration, :competition => @competition, :participant => @peter, :email => "muh2@cow.com"
    end

    it "lists only registered competitors for Munich Open" do
      visit competition_registrations_path(@competition)
      page.should have_link("Dieter Müller", :href => "http://worldcubeassociation.org/results/p.php?i=2008MULL01") # TODO what about linking to a competitors page instead of linking to the WCA profile?
      page.should_not have_content("Peter Müller")
    end

    it "displays amount of competitors and guest" do
      visit competition_registrations_path(@competition)
      within("#competitors") do
        page.should have_content("∑: 1 (1 guest)")
      end
      p = create :participant
      create :registration, :competition => @competition, :participant => p, :days_as_guest => [0]
      visit competition_registrations_path(@competition)
      within("#competitors") do
        page.should have_content("∑: 1 (2 guests)")
      end
    end
  end

  describe "POST /registrations" do
    before :each do
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
      Registration.first.participant.first_name.should == "Peter"
    end

    it "doesn't create a new competitor if his WCA ID already exists" do
      create :participant, :first_name => "Peter", :last_name => "Mustermann", :wca_id => "2008MUST01"
      visit new_competition_registration_path(@competition)
      fill_in_with_peter
      fill_in "WCA ID", :with => "2008MUST01"
      click_on "Register"
      page.should have_content("Successfully registered")
      Participant.count.should == 1
      Registration.count.should == 1
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

      @competition.registrations.first.schedules.should include(@schedule_3)
      @competition.registrations.first.schedules.should include(@schedule_4)
      @competition.registrations.first.schedules.should include(@schedule_py)
      @competition.registrations.first.schedules.should_not include(@schedule_mx)
    end

    it "registers Peter as a guest for Sunday only and does not list him as a competitor" do
      visit new_competition_registration_path(@competition)

      fill_in_with_peter
      check "Guest on Sunday"
      click_on "Register"

      page.should_not have_content("Peter Mustermann")
      @competition.registrations.first.days_as_guest.should == [1]
      @competition.registrations.first.should be_guest
    end

    it "doesn't show events which aren't available for registration" do
      visit new_competition_registration_path(@competition)

      page.should_not have_content(@lunch.event.name)
    end
  end

  describe "GET /registrations/compare" do
    before :each do
      c1 = create :participant, :wca_id => "2003POCH01", :first_name => "Stefan"
      c2 = create :participant, :wca_id => "2007HABE01", :first_name => "Tim"
      c3 = create :participant, :wca_id => "2008AURO01", :first_name => "Basti"
      c4 = create :participant, :wca_id => "2003BRUC01", :first_name => "Ron"
      c5 = create :participant, :first_name => "Thomas"
      c6 = create :participant, :wca_id => "2004CHAN04", :first_name => "Shelley"
      create :registration, :participant => c1, :competition => @competition, :schedules => [@schedule_3]
      create :registration, :participant => c2, :competition => @competition, :schedules => [@schedule_3, @schedule_4bf]
      create :registration, :participant => c3, :competition => @competition, :schedules => [@schedule_3, @schedule_4bf]
      create :registration, :participant => c4, :competition => @competition, :schedules => [@schedule_py]
      create :registration, :participant => c5, :competition => @competition, :schedules => [@schedule_3]
      create :registration, :participant => c6, :competition => @competition, :schedules => [@schedule_py]
    end

    it "displays the competitors in order of their 3x3x3 averages" do
      VCR.use_cassette "compare/3x3x3" do
        visit compare_competition_registrations_path(@competition, :event_id => @three.id)
        within("table.compare tbody") do
          find(:xpath, ".//tr[1]").text.should match("Basti")
          find(:xpath, ".//tr[1]").text.should match("13.50")
          find(:xpath, ".//tr[1]").text.should match("10.46")
          find(:xpath, ".//tr[2]").text.should match("Stefan")
          find(:xpath, ".//tr[2]").text.should match("14.66")
          find(:xpath, ".//tr[2]").text.should match("9.56")
          find(:xpath, ".//tr[3]").text.should match("Tim")
          find(:xpath, ".//tr[3]").text.should match("15.79")
          find(:xpath, ".//tr[3]").text.should match("12.52")
          page.should_not have_content("Ron")
          page.should_not have_content("Thomas")
        end
      end
    end

    it "displays 4x4 BLD properly" do
      VCR.use_cassette "compare/4x4BLD" do
        visit compare_competition_registrations_path(@competition, :event_id => @four_bld.id)
        within("table.compare thead") do
          page.should_not have_content("average")
        end
        within("table.compare tbody") do
          find(:xpath, ".//tr[1]").text.should match("Tim")
          find(:xpath, ".//tr[1]").text.should match("6:50.53")
          find(:xpath, ".//tr[2]").text.should match("Basti")
          find(:xpath, ".//tr[2]").text.should match("13:50.00")
        end
      end
    end

    it "doesn't show people who don't have records for that event" do
      VCR.use_cassette "compare/pyraminx" do
        visit compare_competition_registrations_path(@competition, :event_id => @pyraminx.id)
        within("table.compare tbody") do
          page.should_not have_content("Shelley")
        end
      end
    end
  end
end
