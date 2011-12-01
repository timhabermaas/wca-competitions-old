require "spec_helper"

describe "Schedules" do
  before :each do
    @competition = create :competition, :starts_at => Date.new(2011, 1, 1), :ends_at => Date.new(2011, 1, 2)
    @pyraminx = create :event, :name => "Pyraminx"
    @megaminx = create :event, :name => "Megaminx"
    @lunch = create :event, :name => "Lunch"
  end

  describe "GET /schedules" do
    it "displays events in order" do
      @competition.schedules.create :event => @pyraminx, :day => 0,
                                    :starts_at => Time.new(2011, 1, 1, 14, 30),
                                    :ends_at => Time.new(2011, 1, 1, 15, 30)
      @competition.schedules.create :event => @megaminx, :day => 0,
                                    :starts_at => Time.new(2011, 1, 1, 13, 30),
                                    :ends_at => Time.new(2011, 1, 1, 14, 30)
      @competition.schedules.create :event => @lunch, :day => 1,
                                    :starts_at => Time.new(2011, 1, 1, 12, 0),
                                    :ends_at => Time.new(2011, 1, 1, 13, 0)

      visit competition_schedules_path(@competition)

      within("#schedule") do
        within(".day0") do
          find(:xpath, ".//tr[1]").text.should match("13:30")
          find(:xpath, ".//tr[1]").text.should match("Megaminx")
          find(:xpath, ".//tr[2]").text.should match("14:30")
          find(:xpath, ".//tr[2]").text.should match("Pyraminx")
        end
        within(".day1") do
          find(:xpath, ".//tr[1]").text.should match("12:00")
          find(:xpath, ".//tr[1]").text.should match("Lunch")
        end
      end
    end
  end

  describe "POST /schedules" do
    it "successfully creates a schedule entry" do
      visit new_competition_schedule_path(@competition)
      select "Pyraminx", :from => "Event"
      select "0", :from => "Day"
      fill_in_date "starts_at", :with => Time.new(2011, 1, 1, 14, 0), :model => "schedule"
      click_button "Create Schedule"

      within("#schedule") do
        within(".day0") do
          find(:xpath, ".//tr[1]").text.should match("14:00")
          find(:xpath, ".//tr[1]").text.should match("Pyraminx")
        end
      end
    end
  end
end
