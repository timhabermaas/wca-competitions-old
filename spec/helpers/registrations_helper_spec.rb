require "spec_helper"

describe RegistrationsHelper do
  describe "#format_time" do
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

  describe "#format_mbld" do
    it "outputs 890333804 as '14/18 in 55:38.00'" do
      helper.format_mbld(890333804).should == "14/18 in 55:38.00"
    end

    it "outputs 899999904 as '14/18 in ?'" do
      helper.format_mbld(899999904).should == "14/18 in ?"
    end
  end

  describe "#format_result" do
    it "returns an empty string if the result is not available nil is given" do
      helper.format_result(nil, Event.new).should == ""
    end

    context "given result 890333804" do
      before :each do
        @result = 890333804
      end

      it "outputs '890333804' for fm" do
        helper.format_result(@result, Event.new(:wca => "333fm")).should == "890333804"
      end

      it "outputs '14/18 in 55:38.00' for multiple blindfolded" do
        helper.format_result(@result, Event.new(:wca => "333mbf")).should == "14/18 in 55:38.00"
      end

      it "outputs '2473:08:58.04' for 7x7x7" do
        helper.format_result(@result, Event.new(:wca => "777")).should == "2473:08:58.04"
      end
    end
  end
end
