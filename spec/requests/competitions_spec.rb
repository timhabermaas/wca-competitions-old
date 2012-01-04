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
    let(:competition) { create :competition }

    describe "news" do
      it "displays the latest news" do
        ActiveRecord::Base.record_timestamps = false
        create :news, :content => "old news", :competition => competition, :created_at => DateTime.new(2011, 11, 12)
        ActiveRecord::Base.record_timestamps = true
        create :news, :content => "new news", :competition => competition
        visit competition_path(competition)
        within "#news" do
          find(:xpath, ".//li[1]").text.should match("new news")
          find(:xpath, ".//li[2]").text.should match("old news")
          page.should have_content("2011-11-12")
        end
      end
    end

    context "when competition is closed" do
      let(:competition) { create(:competition, :closed => true) }

      it "doesn't display registration link" do
        visit competition_path(competition)
        page.should_not have_link "Register"
      end
    end

    context "when competition is open" do
      let(:competition) { create(:competition, :closed => false) }

      it "does display registration link" do
        visit competition_path(competition)
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
end
