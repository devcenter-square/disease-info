class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  def not_found
    if env["REQUEST_PATH"] =~ /^\/api/
      render json: {error: 'not-found'}.to_json, status: 404
    else
      render json: {error: "What you are looking for is not found."}.to_json, status: 404 
    end
  end

  def exception
    if env["REQUEST_PATH"] =~ /^\/api/
      render json: {error: "internal-server-error"}.to_json, status: 500
    else
      render json: {error: "500 Internal Server Error"}.to_json, status: 500
    end
  end
  
  def unprocessable_entity
    if env["REQUEST_PATH"] =~ /^\/api/
      render json: {error: "internal-server-error"}.to_json, status: 422
    else
      render text: "The change you wanted was rejected. Try to change only what to have access to", status: 422 
    end
  end
end
