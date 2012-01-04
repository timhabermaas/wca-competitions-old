module Admin
  class NewsController < BaseController
    skip_load_and_authorize_resource
    load_and_authorize_resource :competition
    load_and_authorize_resource :news, :through => :competition

    def new
    end

    def create
      @news = current_user.news.build params[:news]
      @news.competition = @competition
      if @news.save
        redirect_to admin_competition_news_index_path(@competition), :notice => "Successfully created news."
      else
        render :new
      end
    end

    def index
    end

    def edit
    end

    def update
      if @news.update_attributes params[:news]
        redirect_to admin_competition_news_index_path(@competition), :notice => "Successfully updated news."
      else
        render :edit
      end
    end
  end
end
