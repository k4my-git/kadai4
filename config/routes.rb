Rails.application.routes.draw do
  devise_for :users

  resources :users 
  
  resources :books do
  	resources :book_comments, only: [:create, :destroy]
  	resource :favorites, only: [:create, :destroy]
  end
  root 'home#top'
  get 'home/about'
  resources :users do
    resource :relationships, only: [:create, :destroy]
    member do
	    get :follows
	    get :followers
		end
  end
  post 'follow/:id' => 'relationships#follow', as: 'follow'
  post 'unfollow/:id' => 'relationships#unfollow', as: 'unfollow'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
