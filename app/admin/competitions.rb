ActiveAdmin.register Competition do
  controller.load_and_authorize_resource
  controller.skip_load_resource :only => :index

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
      link_to_if current_ability.can?(:index, competition.registrations.build), "Registrations", [:admin, competition, :registrations]
    end
    default_actions
  end

  controller do
    def create
      @competition = current_user.competitions.build params[:competition]
      create!
    end
  end
end
