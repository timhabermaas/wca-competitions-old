ActiveAdmin.register News do
  controller do
    before_filter :current_competition

    load_and_authorize_resource :through => :competition, :except => :index

    def scoped_collection
      end_of_association_chain.accessible_by(current_ability)
    end
  end

  menu :if => proc { current_competition? }

  scope_to :current_competition

  form do |f|
    f.inputs do
      f.input :content
    end
    f.buttons
  end

  controller do
    def create
      @news = current_user.news.build params[:news]
      @news.competition = current_competition
      create!
    end
  end
end
