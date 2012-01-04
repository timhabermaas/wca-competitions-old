module Admin
  class EventsController < BaseController
    def index
    end

    def new
    end

    def create
      if @event.save
        redirect_to admin_events_path, :notice => "Successfully created event."
      else
        render :new
      end
    end

    def edit
    end

    def update
      if @event.update_attributes params[:event]
        redirect_to admin_events_path, :notice => "Successfully updated event."
      else
        render :edit
      end
    end
  end
end
