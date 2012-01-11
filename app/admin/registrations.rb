ActiveAdmin.register Registration do
  controller do
    before_filter :current_competition

    load_and_authorize_resource :through => :competition, :except => :index

    def scoped_collection
      end_of_association_chain.accessible_by(current_ability).includes(:schedules, :participant, :registration_days)
    end
  end

  menu :if => proc { current_competition? }, :label => "Competitors"

  scope_to :current_competition
  scope :all, :default => true
  scope :competitors
  scope :guests

  form :partial => "form"

  index do
    column :full_name do |registration|
      link_to registration.full_name, admin_registration_path(registration)
    end
    column :country
    column :gender do |registration|
      if registration.gender == "f"
        image_tag "female.png"
      else
        image_tag "male.png"
      end
    end
    current_competition.days.each_with_index do |day, index|
      column "#{l day, :format => :short_day_name}", :day do |registration|
        if registration.competitor_on?(index)
          image_tag "competitor.png"
        elsif registration.guest_on?(index)
          image_tag "guest.png"
        end
      end
    end
    column :comment
    column :wca_id do |registration|
      wca_link(registration.wca_id)
    end
    column :email
    column :age
    column :birthday do |registration|
      "x" if registration.participant.has_birthday_during_competition?(current_competition)
    end
    default_actions
  end
end
