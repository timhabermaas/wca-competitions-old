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
    it { should validate_uniqueness_of :name }

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

  it "knows how many days it lasts" do
    competition = Competition.new :starts_at => Date.new(2011, 1, 1), :ends_at => Date.new(2011, 1, 4)
    competition.days.should == 4
    competition = Competition.new :starts_at => Date.new(2011, 1, 31), :ends_at => Date.new(2011, 2, 1)
    competition.days.should == 2
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
