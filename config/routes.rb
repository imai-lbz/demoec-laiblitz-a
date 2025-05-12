Rails.application.routes.draw do
root 'items#index'
resources :items, only:[:index, :dashboard, :show, :new, :edit]

end
