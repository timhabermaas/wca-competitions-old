require 'spec_helper'

describe Ability do
  before :each do
    @admin = create :admin
    @user = create :user
  end

  context "not logged in" do
    before :each do
      @ability = Ability.new(nil)
    end

    it "should be able to register for open competitions" do
      competition = create :competition
      @ability.should be_able_to(:new, Registration.new(:competition => competition))
      @ability.should be_able_to(:create, Registration.new(:competition => competition))
    end

    it "should not be able to register for closed competitions" do
      competition = create :competition, :closed => true
      @ability.should_not be_able_to(:new, Registration.new(:competition => competition))
      @ability.should_not be_able_to(:create, Registration.new(:competition => competition))
    end
  end

  context "logged in as admin" do
    before :each do
      @ability = Ability.new(@admin)
    end

    it "can update news" do
      @ability.should be_able_to(:update, News.new)
    end
  end

  context "logged in as user" do
    before :each do
      @ability = Ability.new(@user)
      @competition = create :competition, :user => @user
    end

    describe "news" do
      it "can only create news to competitions he created" do
        @ability.should be_able_to(:create, @competition.news.build)
        @ability.should_not be_able_to(:create, News.new)
      end

      it "can only update those he created" do
        news = create(:news, :competition => @competition, :user => @user)
        @ability.should be_able_to(:update, news)
        @ability.should_not be_able_to(:update, News.new)
      end
    end

    describe "competitions" do
      it "can create them" do
        @ability.should be_able_to(:create, Competition.new)
      end

      it "can only update those he created" do
        @ability.should be_able_to(:update, @competition)
        @ability.should_not be_able_to(:update, Competition.new)
      end
    end

    describe "schedules" do
      it "can only create schedules for competitions he created" do
        @ability.should be_able_to(:create, @competition.schedules.build)
        @ability.should_not be_able_to(:create, Schedule.new)
      end

      it "can only update schedules for competitions he created" do
        schedule = create(:schedule, :competition => @competition)
        @ability.should be_able_to(:update, schedule)
        @ability.should_not be_able_to(:update, Schedule.new)
      end
    end
  end
end
