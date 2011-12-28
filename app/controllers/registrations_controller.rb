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

    @competitors = @competition.registrations.with_wca_id.for_event(@event).includes(:participant).map do |r| # TODO move to model
      average = r.participant.fastest_average_for @event
      single = r.participant.fastest_single_for @event
      next if single.nil?
      { :participant => r.participant, :single => single, :average => average }
    end.compact.sort_by { |r| [r[:average] || 8_640_000, r[:single]] } # FIXME remove random 24h number
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
