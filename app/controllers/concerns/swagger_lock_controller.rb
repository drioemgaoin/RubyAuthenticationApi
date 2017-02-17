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
         key :description, 'Lock account response'
         schema do
           property :unlock_token do
             key :type, :string
           end
           property :message do
             key :type, :string
           end
         end
       end
       response :default do
         key :description, 'Unexpected error'
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
         key :description, 'Unlock account response'
         schema do
           property :message do
             key :type, :string
           end
         end
       end
       response :default do
         key :description, 'Unexpected error'
         schema do
           key :'$ref', :ErrorModel
         end
       end
     end
    end
  end
end
