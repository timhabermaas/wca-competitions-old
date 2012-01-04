require 'spec_helper'

describe Ability do
  let(:admin) { create :admin }
  let(:organizer) { create :organizer }

  context "not logged in" do
    subject { Ability.new(nil) }

    context "open competition" do
      let(:competition) { create :competition }

      it "should be able to register for open competitions" do
        should be_able_to(:new, Registration.new(:competition => competition))
        should be_able_to(:create, Registration.new(:competition => competition))
      end
    end

    context "closed competition" do
      let(:competition) { create :competition, :closed => true }

      it "should see registrations" do
        should be_able_to(:index, Registration.new(:competition => competition))
      end

      it "should not be able to register" do
        should_not be_able_to(:new, Registration.new(:competition => competition))
        should_not be_able_to(:create, Registration.new(:competition => competition))
      end
    end
  end

  context "logged in as organizer" do
    subject { Ability.new(organizer) }
    let(:competition) { create :competition, :user => organizer }

    describe "news" do
      it "can only create news to competitions he created" do
        should be_able_to(:create, competition.news.build)
        should_not be_able_to(:create, News.new)
      end

      it "can only update those he created" do
        news = create(:news, :competition => competition, :user => organizer)
        should be_able_to(:update, news)
        should_not be_able_to(:update, News.new)
      end
    end

    describe "registrations" do
      it "can update registrations for his own competitions" do
        should be_able_to(:update, competition.registrations.build)
        should_not be_able_to(:update, Registration.new)
      end
    end

    describe "competitions" do
      it "can create them" do
        should be_able_to(:create, Competition.new)
      end

      it "can only update those he created" do
        should be_able_to(:update, competition)
        should_not be_able_to(:update, Competition.new)
      end
    end

    describe "schedules" do
      it "can only create schedules for competitions he created" do
        should be_able_to(:create, competition.schedules.build)
        should_not be_able_to(:create, Schedule.new)
      end

      it "can only update schedules for competitions he created" do
        schedule = create(:schedule, :competition => competition)
        should be_able_to(:update, schedule)
        should_not be_able_to(:update, Schedule.new)
      end
    end
  end
end
