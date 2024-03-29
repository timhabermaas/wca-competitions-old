class SchedulesController < ApplicationController
  before_filter :load_competition
  load_and_authorize_resource :schedule, :through => :competition

  def index
    @schedules = @competition.schedules.order("starts_at").group_by(&:day)
    @schedules.default = []
  end
end
