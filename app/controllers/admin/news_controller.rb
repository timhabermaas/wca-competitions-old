module Admin
  class NewsController < BaseController
    skip_load_and_authorize_resource

    before_filter :fetch_competition

    def new
      @news = @competition.news.build
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
      @news = @competition.news
    end

    def edit
      @news = @competition.news.find params[:id]
    end

    def update
      @news = @competition.news.find params[:id]
      if @news.update_attributes params[:news]
        redirect_to @competition, :notice => "Successfully updated news."
      else
        render :edit
      end
    end

    private
    def fetch_competition
      @competition ||= Competition.find params[:competition_id]
    end
  end
end
