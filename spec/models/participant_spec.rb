require 'spec_helper'

describe Participant do
  describe "validations" do
    before :each do
      create :participant_with_wca_id
      create :participant, :wca_id => ""
    end

    it { should validate_presence_of :first_name }
    it { should validate_presence_of :last_name } # there are people who don't have last names. ARGH!
    it { should validate_presence_of :date_of_birth }
    it { should validate_uniqueness_of :wca_id }

    it "is either male or female" do
      should allow_value("m").for(:gender)
      should allow_value("f").for(:gender)
      should_not allow_value("a").for(:gender)
    end

    it "doesn't complain about duplicated WCA IDs if the WCA ID is left blank" do
      participant = build :participant, :wca_id => ""
      participant.should be_valid
    end
  end

  it "responds with full_name" do
    participant = Participant.new :first_name => "Thom", :last_name => "Pochmann"
    participant.full_name.should == "Thom Pochmann"
  end
end