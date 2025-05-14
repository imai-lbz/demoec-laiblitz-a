Rails.application.routes.draw do
  root 'items#index'
  resources :items, only:[:index, :show, :new, :create, :edit] do
    collection do
      get "dashboard"
    end
  end

  devise_for :users, controllers: {
    registrations: 'devise_user'
  }

  resources :users, only: [:index] do
    collection do
      get "admin_new"
    end
  end
end
