module SwaggerPasswordController
  extend ActiveSupport::Concern

  included do
    include Swagger::Blocks

    swagger_path '/reset/{email}' do
     operation :get do
       key :description, 'Get reset password token'
       key :operationId, 'getResetPasswordToken'
       key :produces, [
          'application/json'
       ]
       key :tags, [
         'Password'
       ]
       parameter do
         key :name, :email
         key :in, :path
         key :description, 'User\'s email'
         key :required, true
         key :type, :string
       end
       response 200 do
         key :description, 'Reset password token response'
         schema do
           property :reset_password_token do
             key :type, :string
           end
           property :message do
             key :type, :string
           end
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

    swagger_path '/reset' do
     operation :post do
       key :description, 'Reset User\'s password'
       key :operationId, 'resetPassword'
       key :produces, [
          'application/json'
       ]
       key :tags, [
         'Password'
       ]
       parameter do
         key :name, "user[reset_password_token]"
         key :in, :formData
         key :description, 'Reset Password Token'
         key :required, true
         key :type, :string
         key :format, :string
       end
       parameter do
         key :name, "user[password]"
         key :in, :formData
         key :description, 'User\'s password'
         key :required, true
         key :type, :string
         key :format, :password
       end
       parameter do
         key :name, "user[password_confirmation]"
         key :in, :formData
         key :description, 'User\'s confirmation password'
         key :required, true
         key :type, :string
         key :format, :password
       end
       response 200 do
         key :description, 'Reset password response'
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
