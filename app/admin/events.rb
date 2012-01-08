ActiveAdmin.register Event do
  controller do
    load_and_authorize_resource :except => :index

    def scoped_collection
      end_of_association_chain.accessible_by(current_ability)
    end

    def index
      authorize! :index, :events
      index!
    end
  end

  menu :if => proc { controller.current_ability.can?(:manage, Event) }
end
