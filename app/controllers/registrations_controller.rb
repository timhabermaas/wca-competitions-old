class RegistrationsController < ApplicationController
  before_filter :find_competition

  def index
    @competitors = @competition.competitors
  end

  def new
    @registration = Registration.new
  end

  def create
    @registration = @competition.registrations.build params[:registration]
    unless params[:registration][:competitor_attributes][:wca_id].blank?
      competitor = Competitor.find_by_wca_id params[:registration][:competitor_attributes][:wca_id]
      @registration.competitor = competitor unless competitor.nil?
    end

    if @registration.save
      redirect_to competition_registrations_path(@competition), :notice => "Successfully registered"
    else
      render :new
    end
  end

  private
  def find_competition
    @competition = Competition.find params[:competition_id]
  end
end
