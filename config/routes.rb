Rails.application.routes.draw do
  post :sign_in, to: 'authentication#sign_in'
  post :sign_up, to: 'authentication#sign_up'
  post '/:provider', to: 'authentication#authenticate', constraints: { provider: /facebook|google/ }

  get 'reset/:email', to: 'password#reset', constraints: { :email => /.*/ }
  post :reset, to: 'password#reset_post'

  post :lock, to: 'lock#lock'
  post :unlock, to: 'lock#unlock'

  get '/user', to: 'user#get_all'
  get '/user/:id', to: 'user#get'

  get '/api' => redirect('/swagger/dist/index.html?url=/apidocs')
  resources :apidocs, only: [:index]
end
