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
    # FIXME what a mess...
    @events = {}
    @competition.registrations.joins(:schedules).group("schedules.event_id").order("count_all DESC").count.each do |event_id, count|
      @events[Event.find event_id] = count
    end

    @countries = @competition.registrations.joins(:participant).group("participants.country").order("count_all DESC").count

    @days = {}
    @competition.days.each_with_index do |day, index|
      @days[day] = { :competitors => @competition.registration_days.for(index).competitor.count,
                     :guests => @competition.registration_days.for(index).guest.count }
    end
  end

  def new
    @competition.days.each_with_index do |day, index|
      @registration.registration_days << RegistrationDay.new
    end
  end

  def create
    if @registration.save
      redirect_to competition_registrations_path(@competition), :notice => "Successfully registered"
    else
      render :new
    end
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
