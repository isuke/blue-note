Rails.application.routes.draw do

  scope path: '/projects/:project_id' do
    get 'progress', to: 'pages#progress'
  end

  resources :projects, only: [], defaults: { format: :json }, shallow: true do
    resources :features, only: [:index]
  end

end
