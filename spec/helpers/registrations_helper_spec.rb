require "spec_helper"

describe RegistrationsHelper do
  describe "#format_time" do
    it "given nil it returns an empty string" do
      helper.format_time(nil).should == ""
    end

    context "english locale" do
      before :each do
        I18n.locale = :en
      end

      it "formats 1324 as 13.24" do
        helper.format_time(1324).should == "13.24"
      end

      it "formats 1304 as 13.04" do
        helper.format_time(1304).should == "13.04"
      end

      it "formats 6000 as 1:00.00" do
        helper.format_time(6000).should == "1:00.00"
      end

      it "formats 360000 as 1:00:00.00" do
        helper.format_time(360000).should == "1:00:00.00"
      end
    end

    context "german locale" do
      before :each do
        I18n.locale = :de
      end

      xit "formats 1324 as 13.24" do
        helper.format_time(1324).should == "13,24"
      end

      xit "formats 1304 as 13.04" do
        helper.format_time(1304).should == "13,04"
      end
    end
  end
end