require "spec_helper"

describe "News" do
  describe "GET /news" do
    before :each do
      @competition = create :competition
    end

    it "displays the latest news" do
      create :news, :content => "old news", :competition => @competition
      create :news, :content => "new news", :competition => @competition
      visit competition_path(@competition)
      within "#news" do
        find(:xpath, ".//li[1]").text.should match("new news")
        find(:xpath, ".//li[2]").text.should match("old news")
      end
    end

    it "doesn't display edit link if not logged in" do
      create :news, :competition => @competition
      visit competition_path(@competition)
      within "#news" do
        page.should_not have_link("Edit")
      end
    end
  end

  describe "POST /news" do
    before :each do
      user = log_in
      @competition = create :competition, :user => user
    end

    it "creates a news entry for an existing competition" do
      visit new_competition_news_path(@competition)
      fill_in "Content", :with => "This competition sucks, just stay away! Seriously!"
      click_on "Create News"
      page.should have_content "Seriously!"
    end

    it "creates a german entry if locale is set to german" do
      click_on "de"
      visit new_competition_news_path(@competition)
      click_on "de"
      fill_in "Content", :with => "Deutsch"
      click_on "Create News"
      page.should have_content "Deutsch"
      click_on "de"
      page.should have_content "Deutsch"
    end
  end

  describe "PUT /news" do
    before :each do
      user = log_in
      @competition = create :competition, :user => user
      create :news, :content => "First news", :competition => @competition, :user => user
    end

    it "updates news entry" do
      visit competition_path(@competition)
      within("#news") do
        click_on "Edit"
      end
      fill_in "Content", :with => "First updated news"
      click_on "Update News"
      page.should have_content "First updated news"
      page.should have_content "Successfully updated news."
    end
  end
end
