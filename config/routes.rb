Rails.application.routes.draw do
  post :sign_in, to: 'auth#sign_in'
  post :sign_up, to: 'auth#sign_up'
  post '/:provider', to: 'auth#authenticate'

  get 'reset/:email', to: 'password#reset'

  get '/api' => redirect('/swagger/dist/index.html?url=/apidocs')
  resources :apidocs, only: [:index]
end
