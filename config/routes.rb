Rails.application.routes.draw do
  post :login, to: 'auth#login'
  post :signup, to: 'auth#signup'
  post '/:provider',      to: 'auth#authenticate'
end
