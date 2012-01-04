require "spec_helper"

describe "Admin::Competitions" do
  describe "POST /competitions" do
    before :each do
      log_in :as => "organizer"
    end

    it "creates a new competition" do
      visit new_admin_competition_path
      fill_in "Name", :with => "Aachen Open 2012"
      fill_in "Starts at", :with => "2012-2-11"
      fill_in "Ends at", :with => "2012-2-13"
      fill_in "Details", :with => "h2. Price Money"
      fill_in "Address", :with => "Fake Street 123\nFake City"
      check "Closed"
      click_button "Create Competition"
      page.should have_content("Competition was successfully created.")
      page.should have_content("Aachen Open 2012")
    end
  end

  describe "PUT /competitions" do
    before :each do
      @user = log_in :as => "organizer"
    end

    it "updates competition name" do
      competition = create :competition, :name => "Karlsruhe Open 2012", :user => @user
      visit edit_admin_competition_path(competition)
      fill_in "Name", :with => "Aachen Open 2012"
      click_button "Update Competition"
      page.should have_content("Competition was successfully updated.")
      page.should have_content("Aachen Open 2012")
    end
  end
end
