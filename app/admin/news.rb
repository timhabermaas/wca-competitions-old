ActiveAdmin.register News do
  belongs_to :competition

  controller do
    skip_load_and_authorize_resource
    load_and_authorize_resource :competition
    load_and_authorize_resource :through => :competition

    def create
      @news = current_user.news.build params[:news]
      @news.competition_id = params[:competition_id]
      create!
    end
  end
end
