class SchedulesController < ApplicationController
  skip_load_and_authorize_resource
  load_and_authorize_resource :competition
  load_and_authorize_resource :schedule, :through => :competition

  def index
    @schedules = @competition.schedules.order("starts_at").group_by(&:day)
    @schedules.default = []
  end

  def new
  end

  def create
    if @schedule.save
      redirect_to competition_schedules_path(@competition)
    else
      render :new
    end
  end
end
