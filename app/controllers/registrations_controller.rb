class RegistrationsController < ApplicationController
  skip_load_and_authorize_resource
  load_and_authorize_resource :competition
  load_and_authorize_resource :registration, :through => :competition

  def index
    @registrations = @registrations.competitor
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
