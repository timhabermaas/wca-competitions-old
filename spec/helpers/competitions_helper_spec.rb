require "spec_helper"

describe CompetitionsHelper do
  describe "#date_range" do
    context "de" do
      before(:each) { I18n.locale = :de }

      it "displays two days in the same month as '18. - 19. September 2011'" do
        helper.date_range(Date.new(2011, 9, 18)..Date.new(2011, 9, 19)).should == "18. - 19. September 2011"
      end

      it "displays two days in different months as '30. November - 1. Dezember 2011'" do
        helper.date_range(Date.new(2011, 11, 30)..Date.new(2011, 12, 1)).should == "30. November -  1. Dezember 2011"
      end

      it "doesn't mess with a range of one date" do
        helper.date_range(Date.new(2011, 9, 18)..Date.new(2011, 9, 18)).should == "18. September 2011"
      end
    end

    context "en" do
      before(:each) { I18n.locale = :en }

      it "displays two days in the same month as 'September 18 - 19, 2011'" do
        helper.date_range(Date.new(2011, 9, 18)..Date.new(2011, 9, 19)).should == "September 18 - 19, 2011"
      end

      it "displays two days in different months as 'November 30 - December 01, 2011'" do
        helper.date_range(Date.new(2011, 11, 30)..Date.new(2011, 12, 1)).should == "November 30 - December 01, 2011"
      end

      it "doesn't mess with a range of one date" do
        helper.date_range(Date.new(2011, 9, 18)..Date.new(2011, 9, 18)).should == "September 18, 2011"
      end
    end
  end
end
