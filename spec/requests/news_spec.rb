require "spec_helper"

describe "News" do
  describe "GET /news" do
    before :each do
      @news = create :news, :content => "huhu"
      @competition = @news.competition
    end

    it "displays the latest news" do
      visit competition_path(@competition)
      page.should have_content("huhu")
    end
  end

  describe "POST /news" do
    it "creates a news entry for an existing competition" do
      competition = create :competition
      visit new_competition_news_path(competition)
      fill_in "Content", :with => "This competition sucks, just stay away! Seriously!"
      click_on "Create News"
      page.should have_content "Seriously!"
    end
  end
end
