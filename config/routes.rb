Rails.application.routes.draw do
  root 'items#index'
  resources :items, only:[:index, :show, :new, :create, :edit, :update, :destroy] do
    collection do
      get "dashboard"
      get 'search', to: 'items#search'
      get ':category_id', to: 'items#category_index', as: :category
    end
    resources :orders, only: [:index, :create]
  end

  devise_for :users, controllers: {
    registrations: 'devise_user'
  }

  resources :users, only: [:index, :destroy] do
    collection do
      get "admin_new"
    end
  end


end
