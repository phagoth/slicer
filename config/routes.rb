Rails.application.routes.draw do
  # namespace the controllers without affecting the URI
  scope module: :v1, constraints: ApiVersion.new('v1', true) do
    resources :videos, only: [:index, :show, :destroy]
    post 'auth/signin', to: 'authentication#authenticate'
    post 'auth/signup', to: 'users#create'
  end

end
