ActiveAdmin.register Competition do
  controller do
    load_and_authorize_resource :except => :index

    def scoped_collection
      end_of_association_chain.accessible_by(current_ability)
    end

    def create
      @competition = current_user.competitions.build params[:competition]
      create!
    end

    def index
      authorize! :index, Competition
      index!
    end
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :starts_at, :as => :datepicker
      f.input :ends_at, :as => :datepicker
      f.input :closed
      f.input :address
      f.input :details
    end
    f.buttons
  end

  index do
    column :name do |competition|
      link_to competition.name, [:admin, competition]
    end
    column :registrations do |competition|
      link_to_if current_ability.can?(:index, competition.registrations.build), "Registrations", [:admin, :registrations]
    end
    default_actions
  end
end
