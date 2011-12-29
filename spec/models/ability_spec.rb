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

    context "open competition" do
      it "should be able to register for open competitions" do
        competition = create :competition
        @ability.should be_able_to(:new, Registration.new(:competition => competition))
        @ability.should be_able_to(:create, Registration.new(:competition => competition))
      end
    end

    context "closed competition" do
      before :each do
        @competition = create :competition, :closed => true
      end

      it "should see registrations" do
        @ability.should be_able_to(:index, Registration.new(:competition => @competition))
      end

      it "should not be able to register" do
        @ability.should_not be_able_to(:new, Registration.new(:competition => @competition))
        @ability.should_not be_able_to(:create, Registration.new(:competition => @competition))
      end
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

  context "logged in as organizer" do
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

    describe "registrations" do
      it "can update registrations for his own competitions" do
        @ability.should be_able_to(:update, @competition.registrations.build)
        @ability.should_not be_able_to(:update, Registration.new)
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
