require "spec_helper"

describe "Admin::Schedules" do
  let(:competition) { @competition = create :competition, :user => @user }

  describe "POST /schedules" do
    before :each do
      @user = log_in :as => "organizer"
      create :event, :name => "Pyraminx"
      create :event, :name => "Megaminx"
    end

    it "successfully creates a schedule entry" do
      visit new_admin_competition_schedule_path(competition)
      select "Pyraminx", :from => "Event"
      select "0", :from => "Day"
      fill_in_date "starts_at", :with => Time.new(2011, 1, 1, 14, 0), :model => "schedule"
      fill_in_date "ends_at", :with => Time.new(2011, 1, 1, 15, 0), :model => "schedule"
      click_button "Create Schedule"
      page.should have_content "Schedule was successfully created."
      page.should have_content "Pyraminx"
    end

    it "successfully creates a schedule entry if ends_at is left blank" do
      visit new_admin_competition_schedule_path(competition)
      select "Pyraminx", :from => "Event"
      select "0", :from => "Day"
      fill_in_date "starts_at", :with => Time.new(2011, 1, 1, 14, 0), :model => "schedule"
      click_button "Create Schedule"
      page.should have_content "Schedule was successfully created."
    end
  end
end
