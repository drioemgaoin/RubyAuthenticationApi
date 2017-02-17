module Swagger
  class UsersModel
    include Swagger::Blocks

    swagger_schema :UsersModel do
      key :required, [:message, :users]
      property :users do
        key :type, :array
        items do
          key :'$ref', :UserModel
        end
      end
      property :message do
        key :type, :string
      end
    end
  end
end
