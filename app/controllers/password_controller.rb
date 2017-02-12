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
       'Reset Password'
     ]
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

  def reset
    reset_password_token = User.new.reset_password_token

    if !reset_password_token.nil?
      render json: {
        reset_password_token: reset_password_token,
        message: I18n.t("authentication.signed_up")
      }
    else
      render_error I18n.t("failure.email_not_exist"), :unprocessable_entity
    end
  end

  def reset_post

  end

  private
    def reset_params
      actual_param = params[:email]
      if params[:format]
        actual_param << "." << params[:format]
      end
    end
end
