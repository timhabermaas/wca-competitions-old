WCACompetitions::Application.routes.draw do
  scope "/(:locale)", :locale => /#{Rails.application.config.available_locales.join("|")}/ do
    get "/log_in" => "sessions#new", :as => "login"
    get "/log_out" => "sessions#destroy", :as => "logout"
    resource :session

    namespace "admin" do
      get "/" => "dashboard#index", :as => "dashboard"
      resources :competitions
      resources :events
    end

    constraints(Subdomain) do
      ActiveAdmin.routes(self)
      match "/" => "competitions#show"

      resources :registrations do
        get "compare", :on => :collection
        get "stats", :on => :collection
      end
      resources :schedules
    end
  end

  match "/:locale" => "competitions#index"
  root :to => "competitions#index"
end
