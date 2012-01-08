ActiveAdmin.register Registration do
  controller do
    skip_load_and_authorize_resource
    load_and_authorize_resource :competition
    load_and_authorize_resource :through => :competition
  end

  menu :if => proc { controller.current_competition }

  scope_to :current_competition

  form :partial => "form"
end
