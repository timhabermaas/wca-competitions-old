require 'spec_helper'

describe News do
  describe "validations" do
    it { should validate_presence_of :content }
    it { should validate_presence_of :competition_id }
    it { should validate_presence_of :user_id }
  end

  describe "translations" do
    after :each do
      I18n.locale = I18n.default_locale
    end

    it "stores content for different languages" do
      news = build :news
      I18n.locale = :en
      news.content = "english news"
      I18n.locale = :de
      news.content = "deutsche nachrichten"
      news.save!
      News.all.first.content.should == "deutsche nachrichten"
      I18n.locale = :en
      News.all.first.content.should == "english news"
    end
  end
end
