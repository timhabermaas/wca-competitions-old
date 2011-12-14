class NewsController < ApplicationController
  skip_load_and_authorize_resource
  load_and_authorize_resource :competition
  load_and_authorize_resource :news, :through => :competition

  def new
  end

  def create
    @news.user = current_user
    if @news.save
      redirect_to @competition
    else
      render :new
    end
  end
end
