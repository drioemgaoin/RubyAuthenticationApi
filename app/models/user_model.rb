class UserModel
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

  swagger_schema :UserModel do
    key :required, [:email, :avatar]
    property :email do
      key :type, :string
    end
    property :avatar do
      key :'$ref', :AvatarModel
    end
  end

  swagger_schema :AvatarModel do
    key :required, [:url, :thumb, :small, :medium]
    property :url do
      key :type, :string
    end
    property :thumb do
      key :type, :string
    end
    property :small do
      key :type, :string
    end
    property :medium do
      key :type, :string
    end
  end
end
