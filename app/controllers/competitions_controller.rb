class CompetitionsController < ApplicationController
  load_and_authorize_resource

  def index
  end

  def new
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
  end
end
