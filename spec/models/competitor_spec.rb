require 'spec_helper'

describe Competitor do
  describe "validations" do
    before :each do
      create :competitor
    end

    it { should validate_presence_of :first_name }
    it { should validate_presence_of :last_name } # there are people who don't have last names. ARGH!
    it { should validate_uniqueness_of :wca_id }

    it "is either male or female" do
      should allow_value("w").for(:gender)
      should allow_value("m").for(:gender)
      should_not allow_value("a").for(:gender)
    end
  end
end
