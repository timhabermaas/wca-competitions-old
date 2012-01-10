ActiveAdmin.register Registration do
  controller do
    before_filter :current_competition

    load_and_authorize_resource :through => :competition, :except => :index

    def scoped_collection
      end_of_association_chain.accessible_by(current_ability)
    end
  end

  menu :if => proc { controller.current_competition? }

  scope_to :current_competition

  form :partial => "form"
end
