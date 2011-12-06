class SchedulesController < ApplicationController
  before_filter :fetch_competition

  def index
    @schedules = @competition.schedules.order("starts_at").group_by(&:day)
    @schedules.default = []
  end

  def new
    @schedule = @competition.schedules.build
  end

  def create
    @schedule = @competition.schedules.build params[:schedule]
    if @schedule.save
      redirect_to competition_schedules_path(@competition)
    else
      render :new
    end
  end

  private
  def fetch_competition
    @competition = Competition.find params[:competition_id]
  end
end
