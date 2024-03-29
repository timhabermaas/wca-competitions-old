require "spec_helper"

describe "Admin::News" do
  before :each do
    @user = log_in :as => "organizer"
  end

  let(:competition) { create :competition, :user => @user }

  describe "GET /news" do
    xit "displays news in all languages" do
      create :news, :competition => competition, :content => "hey!"
      I18n.locale = :de
      competition.news.first.update_attribute :content, "huhu"
      visit_with_subdomain admin_news(competition), competition.subdomain
      page.should have_content "huhu"
      page.should have_content "hey!"
    end
  end

  describe "POST /news" do
    it "creates a news entry for an existing competition" do
      visit_with_subdomain new_admin_news_path, competition.subdomain
      fill_in "Content", :with => "This competition sucks, just stay away! Seriously!"
      click_on "Create News"
      page.should have_content "News was successfully created."
    end

    it "creates a german entry if locale is set to german" do
      Globalize.locale = :de
      visit_with_subdomain new_admin_news_path(:locale => :de), competition.subdomain
      fill_in "Content", :with => "Deutsch"
      click_on "Create News"
      page.should have_content "Deutsch"
      News.with_translations(:de).should have(1).element
      News.with_translations(:en).should be_empty
    end
  end

  describe "PUT /news" do
    let (:news) { create :news, :content => "First news", :competition => competition, :user => @user }

    it "updates news entry" do
      visit_with_subdomain edit_admin_news_path(news), competition.subdomain
      fill_in "Content", :with => "First updated news"
      click_on "Update News"
      page.should have_content "First updated news"
      page.should have_content "News was successfully updated."
    end
  end
end
