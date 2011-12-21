class CompetitionsController < ApplicationController
  def index
  end

  def new
  end

  def create
    @competition = current_user.competitions.build params[:competition]
    if @competition.save
      redirect_to @competition, :notice => "Successfully created competition."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @competition.update_attributes params[:competition]
      redirect_to @competition, :notice => "Successfully updated competition."
    else
      render :edit
    end
  end

  def show
  end
end
