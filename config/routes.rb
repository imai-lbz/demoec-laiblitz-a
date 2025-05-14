Rails.application.routes.draw do
  root 'items#index'
  resources :items, only:[:index, :show, :new, :create, :edit] do
    collection do
      get "dashboard"
    end
  end


  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  resources :users, only: [:index, :new, :create, :destroy] do
    collection do
      get "admin_new"
    end
  end
end
