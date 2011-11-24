WCACompetitions::Application.routes.draw do
  resources :competitions
  resources :events

  root :to => "competitions#index"
end
