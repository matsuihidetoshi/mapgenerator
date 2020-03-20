Rails.application.routes.draw do
  Rails.application.routes.draw do
    namespace 'api' do
      namespace 'v1' do
        resources :users
        resources :parts
      end
    end
  end
  
  root to: 'toppages#index'
  
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  
  get 'signup', to: 'users#new'
  resources :users
  
  resources :parts, only: [:create, :destroy, :new, :edit, :update] 
  
  resources :relationships, only:[:create, :destroy]

  resources :map_formers, only: [:show]
end
