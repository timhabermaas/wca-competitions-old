require 'spec_helper'

describe Event do
  describe "validations" do
    before :each do
      create :event
    end

    it { should validate_presence_of :name }
    it { should validate_uniqueness_of :name }
    it { should validate_presence_of :short_name }
  end

  describe "#official?" do
    it "is official if wca event id is present" do
      Event.new(:wca => "333").should be_official
      Event.new().should_not be_official
    end
  end
end
