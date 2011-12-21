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

  def edit
  end

  def update
    if @news.update_attributes params[:news]
      redirect_to @competition, :notice => "Successfully updated news."
    else
      render :edit
    end
  end
end
