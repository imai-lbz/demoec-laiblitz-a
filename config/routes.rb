Rails.application.routes.draw do
  root 'items#index'
  get 'search', to: 'items#search'
  # get 'category/:category_id', to: 'items#category_index', as: :category
  resources :items, only:[:index, :show, :new, :create, :edit, :update, :destroy] do
    collection do
      get "dashboard"
    end
    resources :orders, only: [:index, :create]
    resource :favorites, only: [:create, :destroy]
    member do
      get :favorite_frame
    end
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
  
  # クーポン
  resources :coupons, only:[:index, :new, :create]

  # プロモーション
  resources :promotions, only:[:index, :new, :create, :edit, :update, :destroy]

  # お知らせ
  resources :notices, only:[:index, :new, :create, :destroy]
end
