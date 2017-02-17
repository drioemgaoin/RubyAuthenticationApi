module Swagger
  class AvatarModel
    include Swagger::Blocks

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
end
