module SwaggerUserController
  extend ActiveSupport::Concern

  included do
    include Swagger::Blocks

    swagger_path '/user' do
     operation :get do
       key :description, 'Get all the users'
       key :operationId, 'getUsers'
       key :produces, [
          'application/json'
       ]
       key :tags, [
         'User'
       ]
       response 200 do
         key :description, 'user response'
         schema do
           key :'$ref', :UsersModel
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
