module Swagger
  class UserModel
    include Swagger::Blocks

    swagger_schema :UserModel do
      key :required, [:id, :email, :first_name, :last_name, :avatar]
      property :id do
        key :type, :integer
      end
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
