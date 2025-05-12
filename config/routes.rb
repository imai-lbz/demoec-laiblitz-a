Rails.application.routes.draw do
root 'items#index'
resources :items, only:[:index, :dashboard, :show, :new, :edit]


  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  resources :users, only: [:index]
end
