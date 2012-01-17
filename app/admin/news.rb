ActiveAdmin.register News do
  controller do
    before_filter :load_competition

    load_and_authorize_resource :through => :competition, :except => :index

    def scoped_collection
      end_of_association_chain.accessible_by(current_ability)
    end
  end

  menu :if => proc { competition_present? }

  scope_to :load_competition

  form do |f|
    f.inputs do
      f.input :content
    end
    f.buttons
  end

  controller do
    def create
      @news = current_user.news.build params[:news]
      @news.competition = @competition
      create!
    end
  end
end
