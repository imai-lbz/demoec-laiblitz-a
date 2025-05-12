Rails.application.routes.draw do
  
resources :items, only:[:index, :dashboard, :show, :new, :edit]

end
