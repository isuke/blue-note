Rails.application.routes.draw do

  scope path: '/projects/:project_id' do
    get 'progress', to: 'pages#progress'
  end

  namespace :api, format: :json do
    resources :projects, only: [], shallow: true do
      resources :features, only: [:index, :create]
    end
  end

end
