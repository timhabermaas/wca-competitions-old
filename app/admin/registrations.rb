ActiveAdmin.register Registration do
  controller do
    before_filter :current_competition

    load_and_authorize_resource :through => :competition, :except => :index

    def scoped_collection
      end_of_association_chain.accessible_by(current_ability)
    end
  end

  menu :if => proc { current_competition? }, :label => "Competitors"

  scope_to :current_competition
  scope :all, :default => true
  scope :competitor
  scope :guest

  form :partial => "form"

  index do
    column :full_name do |registration|
      link_to registration.full_name, admin_registration_path(registration)
    end
    current_competition.days.each_with_index do |day, index|
      column "#{l day, :format => :short_day_name}", :day do |registration|
        if registration.competitor_on?(index)
          "c"
        elsif registration.guest_on?(index)
          "g"
        end
      end
    end
    column :gender
    column :wca_id
    column :country
    column :email
    column :age
    column :birthday do |registration|
      "x" if registration.participant.has_birthday_during_competition?(current_competition)
    end
    default_actions
  end
end
