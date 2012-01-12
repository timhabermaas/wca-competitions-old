WCACompetitions::Application.routes.draw do
  scope "/(:locale)", :locale => /#{Rails.application.config.available_locales.join("|")}/ do
    devise_for :users, ActiveAdmin::Devise.config

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
