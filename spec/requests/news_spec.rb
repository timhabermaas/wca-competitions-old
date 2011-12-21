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
  end
end
