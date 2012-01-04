WCACompetitions::Application.routes.draw do
  scope "/(:locale)", :locale => /#{I18n.available_locales.join("|")}/ do
    get "/log_in" => "sessions#new", :as => "login"
    get "/log_out" => "sessions#destroy", :as => "logout"
    resource :session

    resources :competitions do
      resources :registrations do
        get "compare", :on => :collection
        get "stats", :on => :collection
      end
      resources :schedules
    end

    namespace :admin do
      resources :events
      resources :competitions do
        resources :news
      end
    end
  end



  match "/:locale" => "competitions#index"
  root :to => "competitions#index"
end
