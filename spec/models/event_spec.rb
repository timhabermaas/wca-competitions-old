require 'spec_helper'

describe Event do
  describe "validations" do
    before :each do
      create :event
    end

    it { should validate_presence_of :name }
    it { should validate_uniqueness_of :name }
  end
end
