require 'spec_helper'

describe Schedule do
  describe "validations" do
    it { should validate_presence_of :competition_id }
    it { should validate_presence_of :event_id }
    it { should validate_presence_of :day }
    it { should validate_presence_of :starts_at }

    it "ensures day lies within competition" do
      c = create :competition, :starts_at => Date.new(2011, 11, 1), :ends_at => Date.new(2011, 11, 4)
      [-1, 4, 10].each do |day|
        schedule = build :schedule, :competition => c, :day => day
        schedule.should_not be_valid
        schedule.errors[:day].should_not be_empty
      end
    end

    it "starts before it ends" do
      schedule = build :schedule, :starts_at => Time.new(2011, 11, 1, 14, 0), :ends_at => Time.new(2011, 11, 1, 13, 0)
      schedule.should_not be_valid
      schedule.errors[:ends_at].should_not be_empty
      schedule = build :schedule, :starts_at => Time.new(2011, 11, 1, 14, 0), :ends_at => nil
      schedule.should be_valid
      schedule.errors[:ends_at].should be_empty
      schedule = build :schedule, :starts_at => nil, :ends_at => Time.new(2011, 11, 1, 14, 0)
      schedule.should_not be_valid
      schedule = build :schedule, :starts_at => Time.new(2011, 11, 1, 14, 0), :ends_at => Time.new(2011, 10, 1, 15, 0)
      schedule.should be_valid
    end
  end
end
