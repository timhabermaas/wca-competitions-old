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

  def edit
  end

  def update
    if @event.update_attributes params[:event]
      redirect_to events_path
    else
      render :edit
    end
  end
end
