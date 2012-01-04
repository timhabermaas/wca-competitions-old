class RegistrationsController < ApplicationController
  skip_load_and_authorize_resource
  load_and_authorize_resource :competition
  load_and_authorize_resource :registration, :through => :competition

  def index
    @events = @competition.events.registerable
    @registrations = @registrations.includes(:participant, :schedules).competitor # TODO move to model
  end

  def compare
    params[:event_id] ||= Event.find_by_name("Rubik's Cube").id
    @event = Event.find params[:event_id]

    @competitors = @competition.compare_competitors_for @event
  end

  def stats
    @statistic = Statistic.new @competition
  end

  def new
  end

  def create
    if @registration.save
      redirect_to competition_registrations_path(@competition), :notice => "Successfully registered"
    else
      render :new
    end
  end
end
