module Swagger
  class UsersModel
    include Swagger::Blocks

    swagger_schema :UsersModel do
      key :required, :users
      property :users do
        key :type, :array
        items do
          key :'$ref', :UserModel
        end
      end
    end
  end
end
