Rails.application.routes.draw do

  root 'pages#home'

  get 'home', to: 'pages#home'
  scope path: '/projects/:project_id' do
    get 'progress', to: 'pages#progress'
  end

  namespace :api, format: :json do
    resources :projects, only: [], shallow: true do
      resources :features, only: [:index, :show, :create]
    end
  end

end
