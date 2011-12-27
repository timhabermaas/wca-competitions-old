class RegistrationsController < ApplicationController
  skip_load_and_authorize_resource
  load_and_authorize_resource :competition
  load_and_authorize_resource :registration, :through => :competition

  def index
    @registrations = @registrations.includes(:participant, :schedules).competitor # TODO move to model
  end

  def compare
    params[:event_id] ||= Event.find_by_name("Rubik's Cube").id
    @event = Event.find params[:event_id]

    @competitors = @competition.registrations.with_wca_id.for_event(@event).includes(:participant).map do |r| # TODO move to model
      average = r.participant.fastest_average_for @event
      next if average.nil?
      single = r.participant.fastest_single_for @event
      { :participant => r.participant, :single => single, :average => average }
    end.compact.sort_by { |r| r[:average] }
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
