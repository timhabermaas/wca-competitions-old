require "spec_helper"

describe "Events" do
  before :each do
    log_in :as => "admin"
  end

  describe "GET /events" do
    before :each do
      create :event, :name => "3x3x3"
      create :event, :name => "Team Solve"
    end

    it "displays all events" do
      visit events_path
      page.should have_content("3x3x3")
      page.should have_content("Team Solve")
    end
  end

  describe "POST /events" do
    it "creates a new event" do
      visit new_event_path
      fill_in "Name", :with => "3x3x3"
      fill_in "Short name", :with => "3"
      click_on "Create Event"
      page.should have_content("3x3x3")
    end
  end
end