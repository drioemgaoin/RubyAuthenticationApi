class ApidocsController < ActionController::Base
  include Swagger::Blocks

  swagger_root do
    key :swagger, '2.0'
    info do
      key :version, '1.0.0'
      key :title, 'Authentication API'
      key :description, 'An API proposing all authentication operations'
      contact do
        key :name, 'Romain Diegoni'
      end
      license do
        key :name, 'MIT'
      end
    end
    tag do
      key :name, 'Authentication'
      key :description, 'User authentication'
      externalDocs do
        key :description, 'Find more info here'
        key :url, 'https://swagger.io'
      end
    end
    key :host, 'localhost:3000'
    key :basePath, '/'
    key :consumes, ['application/json']
    key :produces, ['application/json']
  end

  # A list of all classes that have swagger_* declarations.
  SWAGGERED_CLASSES = [
    AuthenticationController,
    PasswordController,
    LockController,
    UserController,
    User,
    Swagger::UserModel,
    Swagger::UsersModel,
    Swagger::AvatarModel,
    Swagger::ErrorModel,
    self,
  ].freeze

  def index
    render json: Swagger::Blocks.build_root_json(SWAGGERED_CLASSES)
  end
end
