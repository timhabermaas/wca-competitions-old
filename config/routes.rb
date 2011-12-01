WCACompetitions::Application.routes.draw do
  get "/log_in" => "sessions#new", :as => "log_in"
  get "/log_out" => "sessions#destroy", :as => "log_out"
  resource :session

  resources :competitions do
    resources :news
    resources :registrations
    resources :schedules
  end
  resources :events

  root :to => "competitions#index"
end
