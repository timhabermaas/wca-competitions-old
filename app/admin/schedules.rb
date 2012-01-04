ActiveAdmin.register Schedule do
  belongs_to :competition

  form do |f|
    f.inputs do
       f.input :event, :required => true, :include_blank => false
       f.input :day, :as => :select, :collection => 0..20, :include_blank => false
       f.input :starts_at, :include_blank => false
       f.input :ends_at, :include_blank => true, :as => :time
       f.input :registerable
    end
    f.buttons
  end

  controller do
    skip_load_and_authorize_resource
    load_and_authorize_resource :competition
    load_and_authorize_resource :through => :competition

    before_filter :kill_date_for_blank_time, :only => [:create, :update] # FIXME formtastic is is broken...

    private
    def kill_date_for_blank_time
      if params[:schedule]["ends_at(4i)"].blank? and params[:schedule]["ends_at(5i)"].blank?
        params[:schedule]["ends_at(1i)"] = params[:schedule]["ends_at(2i)"] = params[:schedule]["ends_at(3i)"] = ""
      end
    end
  end
end
