class NewsController < ApplicationController
  load_and_authorize_resource :competition
  load_and_authorize_resource :news, :through => :competition

  def new
  end

  def create
    if @news.save
      redirect_to @competition
    else
      render :new
    end
  end
end
