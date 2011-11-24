class NewsController < ApplicationController
  def new
    @competition = Competition.find params[:competition_id]
    @news = @competition.news.build
  end

  def create
    @competition = Competition.find params[:competition_id]
    @news = @competition.news.build params[:news]
    if @news.save
      redirect_to @competition
    else
      render :new
    end
  end
end
