class AuthController < ApplicationController
  include Swagger::Blocks

  swagger_path '/sign_in' do
   operation :post do
     key :description, 'Sign-in the user'
     key :operationId, 'signIn'
     key :produces, [
        'application/json'
      ]
     key :tags, [
       'Sign-in'
     ]
     parameter do
       key :name, "user[email]"
       key :in, :formData
       key :description, 'User\'s email'
       key :required, true
       key :type, :string
     end
     parameter do
       key :name, "user[password]"
       key :in, :formData
       key :description, 'User\'s password'
       key :required, true
       key :type, :string
       key :format, :password
     end
     response 200 do
       key :description, 'sign-in response'
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

  swagger_path '/sign_up' do
   operation :post do
     key :description, 'Sign-up the user'
     key :operationId, 'signUp'
     key :produces, [
        'application/json'
     ]
     key :tags, [
       'Sign-up'
     ]
     parameter do
       key :name, "user[email]"
       key :in, :formData
       key :description, 'User\'s email'
       key :required, true
       key :type, :string
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

  def render_data(data, status)
    render json: data, status: status, callback: params[:callback]
  end

  def render_error(message, status = :unprocessable_entity)
    render_data({ code: 402, error: message }, status)
  end

  def render_success(data, status = :ok)
    if data.is_a? String
      render_data({ message: data }, status)
    else
      render_data(data, status)
    end
  end

  def sign_up
    @user = User.create sign_up_params
    render json: { token: Token.encode(@user.id), message: I18n.t("authentication.signed_up") }
  end

  def sign_in
    parameters = sign_in_params
    @user = User.find_by email: parameters[:email] if parameters[:email].present?

    if @user && @user.authenticate(parameters[:password])
      render json: { token: Token.encode(@user.id), message: I18n.t("authentication.signed_in") }
    else
      render json: { code: 402, message: I18n.t("failure.signed_in_invalid") }, status: :unauthorized
    end
  end

  def authenticate
    @oauth = "Oauth::#{params['provider'].titleize}".constantize.new(params)
    if @oauth.authorized?
      @user = User.from_auth(@oauth.formatted_user_data, current_user)
      if @user
        render_success(token: Token.encode(@user.id), id: @user.id, message: I18n.t("authentication.signed_in"))
      else
        render_error I18n.t("failure.account_already_used", provider: params[:provider])
      end
    else
      render_error I18n.t("failure.signed_in_failure", provider: params[:provider])
    end
  end

  private
    def sign_in_params
      params.require(:user).permit(:email, :password)
    end

    def sign_up_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end
end
