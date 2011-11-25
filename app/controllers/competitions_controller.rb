class CompetitionsController < ApplicationController
  def index
    @competitions = Competition.all
  end

  def new
    @competition = Competition.new
  end

  def create
    @competition = current_user.competitions.build params[:competition]
    if @competition.save
      redirect_to @competition
    else
      render :new
    end
  end

  def show
    @competition = Competition.find params[:id]
  end
end
