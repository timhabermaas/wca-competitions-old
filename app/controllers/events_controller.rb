class EventsController < ApplicationController
  def index
  end

  def new
  end

  def create
    if @event.save
      redirect_to events_path
    else
      render :new
    end
  end
end
