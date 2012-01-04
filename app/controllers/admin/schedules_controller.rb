module Admin
  class SchedulesController < BaseController
    skip_load_and_authorize_resource
    load_and_authorize_resource :competition
    load_and_authorize_resource :schedule, :through => :competition

    def new
    end

    def create
      if @schedule.save
        redirect_to admin_competition_schedules_path(@competition), :notice => "Successfully created schedule."
      else
        render :new
      end
    end

    def index
      @schedules = @competition.schedules.order("starts_at").group_by(&:day)
      @schedules.default = [] # FIXME duplicated code
    end
  end
end
