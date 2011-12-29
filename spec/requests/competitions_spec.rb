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

  describe "GET /competitions/1" do
    context "when competition is closed" do
      before { @competition = create(:competition, :closed => true) }

      it "doesn't display registration link" do
        visit competition_path(@competition)
        page.should_not have_link "Register"
      end
    end

    context "when competition is open" do
      before { @competition = create(:competition, :closed => false) }

      it "does display registration link" do
        visit competition_path(@competition)
        page.should have_link "Register"
      end
    end

    describe "details" do
      it "uses textile for displaying details" do
        competition = create(:competition, :details => "h2. Price Money")
        visit competition_path(competition)
        find("article.details h2").should have_content "Price Money"
      end
    end
  end

  describe "POST /competitions" do
    before :each do
      log_in
    end

    it "creates a new competition" do
      visit new_competition_path
      fill_in "Name", :with => "Aachen Open 2012"
      fill_in_date "starts_at", :with => Date.new(2012, 2, 11), :model => "competition"
      fill_in_date "ends_at", :with => Date.new(2012, 2, 13), :model => "competition"
      fill_in "Details", :with => "h2. Price Money"
      fill_in "Address", :with => "Fake Street 123\nFake City"
      check "Closed"
      click_button "Create Competition"
      page.should have_content("Aachen Open 2012")
      page.should have_content("Price Money")
      page.should have_content("Successfully created competition.")
      page.should have_content("Fake Street")
    end
  end

  describe "PUT /competitions" do
    before :each do
      @user = log_in
    end

    it "updates competition name" do
      competition = create :competition, :name => "Karlsruhe Open 2012", :user => @user
      visit edit_competition_path(competition)
      fill_in "Name", :with => "Aachen Open 2012"
      click_button "Update Competition"
      page.should have_content("Aachen Open 2012")
      page.should have_content("Successfully updated competition.")
    end
  end
end
