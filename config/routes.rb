Rails.application.routes.draw do
  resources :messages
  resources :rooms do
    resources :messages
  end
  
  get 'users/index'
  #devise_for :users, path: 'auth', path_names: { sign_in: 'login', sign_out: 'logout' password: 'secret', confirmation: 'verification', unlock: 'unlock', registration: 'register', sign_up: 'cmon_let_me_in' }
  devise_for :users, :path_prefix => 'd'
  resources :projects
  get 'home/index'

  get 'home/about'
  root 'home#index'
  match '/users', to: 'users#index', via: 'get'
  match '/users/:id', to: 'users#show', via: 'get'
  put 'admin/:id' => 'users#admin', :as => "admin"
  put 'remove_admin/:id' => 'users#remove_admin', :as => "remove_admin"
  delete 'remove/:id' => 'users#remove', :as => "remove"
  delete "attachments/:id/purge", to: "projects#delete_attachment", as: "delete_attachment"
#  devise_for :users, :path_prefix => 'd'
  resources :users, :only => [:show]

  #resources :projects do
   # collection do
    #  get :mine
    #end
#  end



  # Defines the root path route ("/")
  # root "articles#index"
end
