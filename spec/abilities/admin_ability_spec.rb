require "spec_helper"

describe AdminAbility do
  let(:organizer) { create :organizer }
  let(:admin) { create :admin }

  context "logged in as organizer" do
    subject { AdminAbility.new(organizer) }
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
