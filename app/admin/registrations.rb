ActiveAdmin.register Registration do
  belongs_to :competition

  form :partial => "form"

  controller do
    skip_load_and_authorize_resource
    load_and_authorize_resource :competition
    load_and_authorize_resource :through => :competition
  end

  index do
    default_actions
  end
end
