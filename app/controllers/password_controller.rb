class PasswordController < ApplicationController
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
       key :description, 'reset password token response'
       schema do
         key :reset_password_token, :string
         key :message, :string
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
       key :description, 'sign-up response'
       schema do
         key :token, :string
         key :message, :string
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

  def reset
    unlock_token = User.send_reset_password_token({ email: params[:email] })

    if !unlock_token.nil?
      render json: {
        unlock_token: unlock_token,
        message: I18n.t("lock.unlock_token")
      }
    else
      render_error I18n.t("failure.unlock_token", provider: params[:provider])
    end
  end

  def reset_post
    user = User.reset_password_by_token(reset_params)

    if user.errors.empty?
      render json: {
        message: I18n.t("password.reset_password")
      }
    else
      render_error user.full_errors, :unprocessable_entity
    end
  end

  private
  def reset_params
    params.require(:user).permit(:reset_password_token, :password, :password_confirmation)
  end
end
