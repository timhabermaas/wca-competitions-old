require "spec_helper"

describe "Admin::Events" do
  before :each do
    log_in :as => "admin"
  end

  describe "GET /events" do
    before :each do
      create :event, :name => "3x3x3"
      create :event, :name => "Team Solve"
    end

    it "displays all events" do
      visit admin_events_path
      page.should have_content("3x3x3")
      page.should have_content("Team Solve")
    end

    it "has edit link" do
      visit admin_events_path
      click_on "Edit"
      page.should have_content "Name"
    end
  end

  describe "POST /events" do
    it "creates a new event" do
      visit new_admin_event_path
      fill_in "Name", :with => "3x3x3"
      fill_in "Short name", :with => "3"
      fill_in "Wca", :with => "333"
      click_on "Create Event"
      page.should have_content("Event was successfully created.")
      page.should have_content("3x3x3")
    end
  end

  describe "PUT /events" do
    it "updates event name " do
      event = create :event, :name => "3x3x3"
      visit edit_admin_event_path(event)
      fill_in "Name", :with => "2x2x2"
      click_on "Update Event"
      page.should have_content("Event was successfully updated.")
      page.should have_content("2x2x2")
    end
  end
end
