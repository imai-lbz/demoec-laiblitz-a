Rails.application.routes.draw do
  root 'items#index'
  resources :items, only:[:index, :show, :new, :create, :edit, :update, :destroy] do
    collection do
      get "dashboard"
    end
    resources :orders, only: [:index, :create]
    resource :favorites, only: [:create, :destroy]
  end

  # ユーザー認証
  devise_for :users, controllers: {
    registrations: 'devise_user'
  }

  # ユーザー管理
  resources :users, only: [:index, :destroy] do
    collection do
      get "admin_new"
    end
  end

  # マイページ
  get 'mypage', to: 'users#show'
end
