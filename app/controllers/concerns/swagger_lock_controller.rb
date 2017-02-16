module SwaggerLockController
  extend ActiveSupport::Concern

  included do
    include Swagger::Blocks

    swagger_path '/lock' do
     operation :post do
       key :description, 'Lock the account'
       key :operationId, 'lockAccount'
       key :produces, [
          'application/json'
       ]
       key :tags, [
         'Account'
       ]
       parameter do
         key :name, 'user[email]'
         key :in, :formData
         key :description, 'User\'s email'
         key :required, true
         key :type, :string
       end
       response 200 do
         key :description, 'lock account response'
         schema do
           key :unlock_token, :string
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

    swagger_path '/unlock' do
     operation :post do
       key :description, 'Unlock the account'
       key :operationId, 'unlockAccount'
       key :produces, [
          'application/json'
       ]
       key :tags, [
         'Account'
       ]
       parameter do
         key :name, 'user[unlock_token]'
         key :in, :formData
         key :description, 'Unlock token'
         key :required, true
         key :type, :string
       end
       response 200 do
         key :description, 'unlock account response'
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
  end
end
