require "spec_helper"

describe "Competitions" do
  describe "GET /competitions" do
    before :each do
      create(:competition, :name => "Karlsruhe 2011")
      create(:competition, :name => "Aachen Open 2123")
    end

    it "displays competition names" do
      visit competitions_path
      page.should have_content("Karlsruhe 2011")
      page.should have_content("Aachen Open 2123")
    end
  end

  describe "POST /competitions" do
    it "creates new competition" do
      visit new_competition_path
      fill_in "Name", :with => "Aachen Open 2012"
      fill_in_date "starts_at", :with => Date.new(2012, 2, 11), :model => "competition"
      fill_in_date "ends_at", :with => Date.new(2012, 2, 13), :model => "competition"
      click_button "Create Competition"
      page.should have_content("Aachen Open 2012")
    end
  end
end
