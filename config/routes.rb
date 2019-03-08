Rails.application.routes.draw do
  root to: 'toppages#index'
  
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  
  get 'signup', to: 'users#new'
  resources :users, only: [:index, :show, :new, :create, :destroy]
  
  resources :parts, only: [:create, :destroy, :new, :edit, :update] 
  
  resources :relationships, only:[:create, :destroy]

  resources :map_formers, only: [:show]
  
  get '/print/:id', to: 'parts#print', as: 'print'
end
