ActiveAdmin.register Event do
  controller.load_and_authorize_resource
  controller.skip_load_resource :only => :index
end
