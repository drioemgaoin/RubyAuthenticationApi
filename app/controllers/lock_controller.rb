class LockController < ApplicationController
  include Swagger::Blocks

  swagger_path '/lock/{email}' do
   operation :post do
     key :description, 'Lock the account'
     key :operationId, 'lockAccount'
     key :produces, [
        'application/json'
     ]
     key :tags, [
       'Lock/Unlock Account'
     ]
     parameter do
       key :name, 'user[email]'
       key :in, :formData
       key :description, 'User\'s email'
       key :required, true
       key :type, :string
     end
     response 200 do
       key :description, 'lock account response'
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

  def lock
    unlock_token = User.send_unlock_instructions(lock_params)

    if !unlock_token.nil?
      render json: {
        unlock_token: unlock_token,
        message: I18n.t("lock.unlock_token")
      }
    else
      render_error I18n.t("failure.unlock_token", provider: params[:provider])
    end
  end

  def lock_params
    params.require(:user).permit(:email)
  end
end
