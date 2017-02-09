class ErrorModel
  include Swagger::Blocks

  swagger_schema :ErrorModel do
    key :required, [:errors]
    property :errors do
      key :type, :array
      items do
        key :type, :string
      end
    end
  end
end
