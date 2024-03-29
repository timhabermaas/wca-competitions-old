require 'spec_helper'

describe Competition do
  describe "validations" do
    before :each do
      create :competition
    end

    it { should validate_presence_of :name }
    it { should validate_presence_of :starts_at }
    it { should validate_presence_of :ends_at }
    it { should validate_presence_of :user_id }
    it { should validate_presence_of :subdomain }
    it { should validate_uniqueness_of :name }
    it { should validate_uniqueness_of :subdomain }

    it "keeps subdomain size between 2 and 20 characters" do
      competition = build :competition, :subdomain => "1211fdlfslafsafasdfaslfksafsd"
      competition.should_not be_valid
      competition.errors[:subdomain].should_not be_empty
      competition = build :competition, :subdomain => "e"
      competition.should_not be_valid
      competition.errors[:subdomain].should_not be_empty
    end

    it "ensures subdomain is alphanumeric only" do
      competition = build :competition, :subdomain => "ada/2da"
      competition.should_not be_valid
      competition.errors[:subdomain].should_not be_empty
      competition = build :competition, :subdomain => "ada-2da"
      competition.should_not be_valid
      competition.errors[:subdomain].should_not be_empty
    end

    it "starts before it ends" do
      competition = build(:competition, :starts_at => Date.new(2011, 2, 13),
                                        :ends_at => Date.new(2011, 2, 11))
      competition.should_not be_valid
      competition.errors[:ends_at].should_not be_empty
      competition = build(:competition, :starts_at => Date.new(2011, 2, 13),
                                        :ends_at => Date.new(2011, 2, 13))
      competition.should be_valid
    end
  end

  describe "#days" do
    it "returns all dates for the competition" do
      competition = Competition.new :starts_at => Date.new(2011, 1, 31), :ends_at => Date.new(2011, 2, 2)
      days = competition.days.to_a
      days.size.should == 3
      days[0].should == Date.new(2011, 1, 31)
      days[1].should == Date.new(2011, 2, 1)
      days[2].should == Date.new(2011, 2, 2)
    end
  end

  describe "#amount_of_days" do
    it "returns 3 for a three day competition" do
      competition = Competition.new :starts_at => Date.new(2011, 1, 31), :ends_at => Date.new(2011, 2, 2)
      competition.amount_of_days.should == 3
    end
  end

  it "knows all available schedules for each day" do
    competition = create :competition
    three = create(:event, :name => "3x3x3")
    four = create(:event, :name => "4x4x4")
    s1 = create :schedule, :competition => competition, :event => three, :day => 0
    s2 = create :schedule, :competition => competition, :event => three, :day => 0
    s3 = create :schedule, :competition => competition, :event => four, :day => 1
    competition.schedules.for(0).should include(s1)
    competition.schedules.for(0).should include(s2)
    competition.schedules.for(1).should include(s3)
  end
end
