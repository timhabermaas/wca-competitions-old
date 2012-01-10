require "spec_helper"

describe "Admin::Registrations" do
  describe "PUT /registrations/" do
    use_vcr_cassette "requests/registrations/update", :record => :new_episodes

    before :each do
      log_in :as => "admin"
      @competition = create :competition
      @event_3 = create :event, :name => "3x3x3"
      @event_py = create :event, :name => "Pyraminx"
      @schedule_3 = create :schedule, :event => @event_3, :competition => @competition, :day => 0
      @schedule_py = create :schedule, :event => @event_py, :competition => @competition, :day => 1
    end

    it "changes name of Peter to Karl and removes him from 3x3x3 to add him to Pyraminx" do
      r = create_registration :participant => build(:participant, :first_name => "Peter"), :competition => @competition, :schedules => [@schedule_3]
      visit_with_subdomain edit_admin_registration_path(r), @competition.subdomain
      fill_in "First name", :with => "Karl"
      within(".day1") do
        choose "I'll be there"
      end
      save_and_open_page
      check "Pyraminx"
      uncheck "3x3x3"
      click_on "Update Registration"
      page.should have_content "Karl"
      Registration.first.schedules.should include(@schedule_py)
      Registration.first.schedules.should_not include(@schedule_3)
      Registration.first.registration_days.guest.first.day.should == 0
      Registration.first.registration_days.competitor.first.day.should == 1
    end
  end
end
