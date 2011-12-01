class SchedulesController < ApplicationController
  def index
    @competition = Competition.find params[:competition_id]
    @schedules = @competition.schedules.order("starts_at").group_by(&:day)
    @schedules.default = []
  end

  def new
    @competition = Competition.find params[:competition_id]
    @schedule = @competition.schedules.build
  end

  def create
    @competition = Competition.find params[:competition_id]
    @schedule = @competition.schedules.build params[:schedule]
    if @schedule.save
      redirect_to competition_schedules_path(@competition)
    else
      render :new
    end
  end
end
