require 'spec_helper'

describe Statistic do
  before :each do
    Participant.any_instance.stub(:country_is_existent)
    @competition = create :competition, :starts_at => Date.new(2011, 11, 26), :ends_at => Date.new(2011, 11, 27)
    @events = create_list :event, 5
    @schedules = []
    @schedules[0] = create :schedule, :event => @events[0], :competition => competition, :day => 0, :registerable => true
    @schedules[1] = create :schedule, :event => @events[1], :competition => competition, :day => 0, :registerable => true
    @schedules[2] = create :schedule, :event => @events[2], :competition => competition, :day => 1, :registerable => true
    @schedules[3] = create :schedule, :event => @events[3], :competition => competition, :day => 1, :registerable => true
    @schedules[4] = create :schedule, :event => @events[4], :competition => competition, :day => 1, :registerable => true
  end

  let(:competition) { create(:competition, :starts_at => Date.new(2011, 11, 26), :ends_at => Date.new(2011, 11, 27)) }
  subject { Statistic.new competition }

  describe "#events" do
    before :each do
      create_registration :competition => competition, :schedules => @schedules[0..2]
      create_registration :competition => competition, :schedules => @schedules[1..4]
    end

    it "has two people registered for events 1 and 2 and one for all other events" do
      subject.events[@events[0]].should == 1
      subject.events[@events[1]].should == 2
      subject.events[@events[2]].should == 2
      subject.events[@events[3]].should == 1
      subject.events[@events[4]].should == 1
    end
  end

  describe "#countries" do
    before :each do
      2.times do
        create_registration :competition => competition, :schedules => [@schedules[0]], :participant => build(:participant, :country => "France")
      end
      3.times do
        create_registration :competition => competition, :schedules => [@schedules[0]], :participant => build(:participant, :country => "Germany")
      end
      create_registration :competition => competition, :guest_days => [0], :participant => build(:participant, :country => "Italy")
    end

    xit "has three people from Germany and two from France competing" do
      subject.countries["France"].should == 2
      subject.countries["Germany"].should == 3
      subject.countries["Italy"].should == nil
    end
  end

  describe "#days" do
    before :each do
      create_registration :competition => competition, :schedules => @schedules[0..4] # both days
      create_registration :competition => competition, :schedules => @schedules[0..1] # only day 0
      create_registration :competition => competition, :schedules => @schedules[3..4] # only day 1
      create_registration :competition => competition, :schedules => @schedules[4..4] # only day 1
      create_registration :competition => competition, :guest_days => [0,1] # both days
      create_registration :competition => competition, :guest_days => [1] # only day 1
    end

    it "has one guest for day 0 and two guests for day 1" do
      subject.days[competition.days.first][:guests].should == 1
      subject.days[competition.days.last][:guests].should == 2
    end

    it "has two competitors for day 0 and three competitors for day 1" do
      subject.days[competition.days.first][:competitors].should == 2
      subject.days[competition.days.last][:competitors].should == 3
    end
  end
end
