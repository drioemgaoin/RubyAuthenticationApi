Rails.application.routes.draw do
  post :sign_in, to: 'auth#sign_in'
  post :sign_up, to: 'auth#sign_up'
  post '/:provider', to: 'auth#authenticate', :constraints => { :provider => /[facebook|google]/ }

  get 'reset/:email', to: 'password#reset', :constraints => { :email => /.*/ }
  post 'reset', to: 'password#reset_post'

  post 'lock', to: 'lock#lock'
  post 'unlock', to: 'lock#unlock'

  get '/api' => redirect('/swagger/dist/index.html?url=/apidocs')
  resources :apidocs, only: [:index]
end
