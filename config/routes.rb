Rails.application.routes.draw do

  root 'pages#home'

  get 'home'     , to: 'pages#home'
  get 'dashboard', to: 'pages#dashboard'
  scope path: '/projects/:project_id' do
    get 'progress', to: 'pages#progress'
    get 'project_settings', to: 'pages#project_settings'
  end

  namespace :api, format: :json do
    resources :users   , only: [:create]
    resources :projects, only: [:index, :create], shallow: true do
      resources :members   , only: [:index, :create]
      resources :iterations, only: [:index]
      resources :features  , only: [:index, :show, :create, :update] do
        patch  :update_priority, on: :member
        patch  :update_all , on: :collection
        delete :destroy_all, on: :collection
      end
    end
    match '/sign_up', to: 'users#create'         , via: :post
    match '/login'  , to: 'user_sessions#create' , via: :post
    match '/logout' , to: 'user_sessions#destroy', via: :DELETE
  end

end
