module Admin
  class RegistrationsController < BaseController
    skip_load_and_authorize_resource
    load_and_authorize_resource :competition
    load_and_authorize_resource :registration, :through => :competition

    def index
      @events = @competition.events.registerable
      @registrations = @registrations.includes(:participant, :schedules).competitor # TODO move to model
    end

    def edit
    end

    def update
      if @registration.update_attributes params[:registration]
        redirect_to competition_registrations_path(@competition), :notice => "Successfully updated"
      else
        render :edit
      end
    end
  end
end
