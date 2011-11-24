require 'spec_helper'

describe Event do
  describe "validations" do
    it { should validate_presence_of :name }

    it "validates uniqueness of name" do
      event1 = create :event
      event2 = build :event, :name => event1.name
      event2.should_not be_valid
      event2.errors[:name].should_not be_blank
    end
  end
end
