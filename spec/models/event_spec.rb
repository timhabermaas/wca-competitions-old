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

  it "converts blank wca attribute to nil before saving" do
    event = create :event, :wca => " "
    Event.first.wca.should be_nil
  end

  describe "scopes" do
    describe ".official" do
      it "is official if wca event id is present" do
        event1 = create :event, :wca => "333"
        event2 = create :event, :wca => "444"
        2.times { create :event }
        Event.official.should have(2).elements
        Event.official.should include(event1)
        Event.official.should include(event2)
      end
    end
  end
end
