require "spec_helper"

describe RegistrationsHelper do
  describe "#format_time" do
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