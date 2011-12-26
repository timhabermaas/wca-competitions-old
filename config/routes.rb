WCACompetitions::Application.routes.draw do
  scope "/(:locale)", :locale => /#{I18n.available_locales.join("|")}/ do
    get "/log_in" => "sessions#new", :as => "log_in"
    get "/log_out" => "sessions#destroy", :as => "log_out"
    resource :session

    resources :competitions do
      resources :news
      resources :registrations do
        get "compare", :on => :collection
      end
      resources :schedules
    end
    resources :events
  end

  match "/:locale" => "competitions#index"
  root :to => "competitions#index"
end
