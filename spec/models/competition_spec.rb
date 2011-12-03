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

  it "knows all available events for each day" do
    competition = create :competition
    three = create(:event, :name => "3x3x3")
    four = create(:event, :name => "4x4x4")
    create :schedule, :competition => competition, :event => three, :day => 0
    create :schedule, :competition => competition, :event => three, :day => 0
    create :schedule, :competition => competition, :event => four, :day => 1
    competition.events.for(0).should have(1).item
    competition.events.for(0).should include(three)
    competition.events.for(1).should include(four)
  end
end
