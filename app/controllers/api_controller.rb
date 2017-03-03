class ApiController < ActionController::API
  def index
    redirect_to '/swagger/dist/index.html?url=/apidocs'
  end
end
