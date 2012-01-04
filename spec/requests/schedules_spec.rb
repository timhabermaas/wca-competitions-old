require "spec_helper"

describe "Schedules" do
  before :each do
    @competition = create :competition, :starts_at => Date.new(2011, 12, 2), :ends_at => Date.new(2011, 12, 3)
    @pyraminx = create :event, :name => "Pyraminx"
    @megaminx = create :event, :name => "Megaminx"
    @lunch = create :event, :name => "Lunch"
  end

  describe "GET /schedules" do
    before :each do
      @competition.schedules.create :event => @pyraminx, :day => 0,
                                    :starts_at => Time.new(2011, 1, 1, 14, 30),
                                    :ends_at => Time.new(2011, 1, 1, 15, 30)
      @competition.schedules.create :event => @megaminx, :day => 0,
                                    :starts_at => Time.new(2011, 1, 1, 13, 30),
                                    :ends_at => Time.new(2011, 1, 1, 14, 30)
      @competition.schedules.create :event => @lunch, :day => 1,
                                    :starts_at => Time.new(2011, 1, 1, 12, 0),
                                    :ends_at => Time.new(2011, 1, 1, 13, 0)
    end

    it "displays events in order" do
      visit competition_schedules_path(@competition)

      within("#schedule") do
        within(".day0 tbody") do
          find(:xpath, ".//tr[1]").text.should match("13:30")
          find(:xpath, ".//tr[1]").text.should match("Megaminx")
          find(:xpath, ".//tr[2]").text.should match("14:30")
          find(:xpath, ".//tr[2]").text.should match("Pyraminx")
        end
        within(".day1 tbody") do
          find(:xpath, ".//tr[1]").text.should match("12:00")
          find(:xpath, ".//tr[1]").text.should match("Lunch")
        end
      end
    end

    it "displays descriptive dates for each day" do
      visit competition_schedules_path(@competition)

      find(:xpath, ".//h3[1]").text.should match("Friday, December 02, 2011")
      find(:xpath, ".//h3[2]").text.should match("Saturday, December 03, 2011")
    end
  end
end
