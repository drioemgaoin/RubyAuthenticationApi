module SwaggerAuthenticationController
  extend ActiveSupport::Concern

  included do
    include Swagger::Blocks

    swagger_path '/sign_in' do
     operation :post do
       key :description, 'Sign-in the user'
       key :operationId, 'signIn'
       key :produces, [
          'application/json'
        ]
       key :tags, [
         'Sign-in'
       ]
       parameter do
         key :name, "user[email]"
         key :in, :formData
         key :description, 'User\'s email'
         key :required, true
         key :type, :string
       end
       parameter do
         key :name, "user[password]"
         key :in, :formData
         key :description, 'User\'s password'
         key :required, true
         key :type, :string
         key :format, :password
       end
       response 200 do
         key :description, 'sign-in response'
         schema do
           key :access_token, :string
           key :message, :string
         end
       end
       response :default do
         key :description, 'unexpected error'
         schema do
           key :'$ref', :ErrorModel
         end
       end
     end
    end

    swagger_path '/sign_up' do
     operation :post do
       key :description, 'Sign-up the user'
       key :operationId, 'signUp'
       key :produces, [
          'application/json'
       ]
       key :tags, [
         'Sign-up'
       ]
       parameter do
         key :name, "user[email]"
         key :in, :formData
         key :description, 'User\'s email'
         key :required, true
         key :type, :string
       end
       parameter do
         key :name, "user[password]"
         key :in, :formData
         key :description, 'User\'s password'
         key :required, true
         key :type, :string
         key :format, :password
       end
       parameter do
         key :name, "user[password_confirmation]"
         key :in, :formData
         key :description, 'User\'s confirmation password'
         key :required, true
         key :type, :string
         key :format, :password
       end
       response 200 do
         key :description, 'sign-up response'
         schema do
           key :message, :string
         end
       end
       response :default do
         key :description, 'unexpected error'
         schema do
           key :'$ref', :ErrorModel
         end
       end
     end
    end

    swagger_path '/facebook' do
     operation :post do
       key :description, 'Sign-in the user via facebook'
       key :operationId, 'signInFacebook'
       key :produces, [
          'application/json'
       ]
       key :tags, [
         'Sign-in'
       ]
       parameter do
         key :name, "access_token"
         key :in, :formData
         key :description, 'Access token'
         key :required, false
         key :type, :string
         key :format, :string
       end
       response 200 do
         key :description, 'sign-in via facebook response'
         schema do
           key :token, :string
           key :message, :string
         end
       end
       response :default do
         key :description, 'unexpected error'
         schema do
           key :'$ref', :ErrorModel
         end
       end
     end
    end

    swagger_path '/google' do
     operation :post do
       key :description, 'Sign-in the user via google'
       key :operationId, 'signInGoogle'
       key :produces, [
          'application/json'
       ]
       key :tags, [
         'Sign-in'
       ]
       parameter do
         key :name, "access_token"
         key :in, :formData
         key :description, 'Access token'
         key :required, false
         key :type, :string
         key :format, :string
       end
       response 200 do
         key :description, 'sign-in via google response'
         schema do
           key :token, :string
           key :message, :string
         end
       end
       response :default do
         key :description, 'unexpected error'
         schema do
           key :'$ref', :ErrorModel
         end
       end
     end
    end
  end
end
