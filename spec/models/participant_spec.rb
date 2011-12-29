require 'spec_helper'

describe Participant do
  describe "validations" do
    use_vcr_cassette "models/participant/validations", :record => :new_episodes

    it { should validate_presence_of :first_name }
    it { should validate_presence_of :last_name } # there are people who don't have last names. ARGH!
    it { should validate_presence_of :date_of_birth }
    it { should validate_presence_of :country }

    it "should require case sensitive unique value for wca_id" do
      Participant.any_instance.stub(:country_is_existent)
      Participant.any_instance.stub(:wca_id_is_existent)
      create(:participant_with_wca_id)
      should validate_uniqueness_of :wca_id
    end

    it "is either male or female" do
      should allow_value("m").for(:gender)
      should allow_value("f").for(:gender)
      should_not allow_value("a").for(:gender)
    end

    it "needs an existing wca id" do
      build(:participant, :wca_id => "2007HABE01").should be_valid
      build(:participant, :wca_id => " ").should be_valid

      participant = build(:participant, :wca_id => "2003MUHU02")
      participant.should_not be_valid
      participant.errors[:wca_id].should_not be_empty
      participant = build(:participant, :wca_id => "dasfsfsaf")
      participant.should_not be_valid
      participant.errors[:wca_id].should_not be_empty
    end

    it "requires country to be included in WCA list of countries" do
      p = build(:participant, :country => "Muh")
      p.should_not be_valid
      p.errors[:country].should_not be_empty
    end
  end

  it "responds with full_name" do
    participant = Participant.new :first_name => "Thom", :last_name => "Pochmann"
    participant.full_name.should == "Thom Pochmann"
  end

  it "converts blank wca_id to nil after initialization" do
    participant = Participant.new :wca_id => " "
    participant.wca_id.should be_nil
  end

  describe "#fastest_*_for" do
    use_vcr_cassette "models/participant/fastest_for", :record => :new_episodes

    before :each do
      @three = create :event, :name => "Rubik's Cube", :wca => "333"
      @six = create :event, :name => "6x6x6", :wca => "666"
    end

    it "returns 1466 for Stefan's 333 average" do
      participant = build :participant, :wca_id => "2003POCH01"
      participant.fastest_average_for(@three).should == 1466
    end

    it "returns 956 for Stefan's 333 single" do
      participant = build :participant, :wca_id => "2003POCH01"
      participant.fastest_single_for(@three).should == 956
    end

    it "returns nil if the person has no best single for that event" do
      participant = build :participant, :wca_id => "2004NOOR01"
      participant.fastest_single_for(@six).should be_nil
    end

    it "returns nil if the person has no best average for that event" do
      participant = build :participant, :wca_id => "2004NOOR01"
      participant.fastest_average_for(@six).should be_nil
    end
  end
end
