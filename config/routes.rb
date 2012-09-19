RailsBaseApplication::Application.routes.draw do
  devise_for :users

  # root path application
  root :to => 'home#show'
end
