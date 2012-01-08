ActiveAdmin.register News do
  controller do
    skip_load_and_authorize_resource
    load_and_authorize_resource :competition
    load_and_authorize_resource :through => :competition
  end

  menu :if => proc { controller.current_competition }

  scope_to :current_competition

  controller do
    def create
      @news = current_user.news.build params[:news]
      @news.competition_id = params[:competition_id]
      create!
    end
  end
end
