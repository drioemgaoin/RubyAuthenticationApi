module Swagger
  class UserModel
    include Swagger::Blocks

    swagger_schema :UserModel do
      key :required, [:email, :avatar]
      property :email do
        key :type, :string
      end
      property :first_name do
        key :type, :string
      end
      property :last_name do
        key :type, :string
      end
      property :avatar do
        key :'$ref', :AvatarModel
      end
    end
  end
end
