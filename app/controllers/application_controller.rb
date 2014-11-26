class ApplicationController < ActionController::API
  include ActionController::MimeResponds
  include ActionController::HttpAuthentication::Token::ControllerMethods

  attr_reader :current_user

  respond_to :json

  private

  def authenticate
    @current_user ||= authenticate_with_http_token { |token, options| User.find_by_token token }
    @current_user || render( json: 'Invalid Token', status: 401 )
  end

  def authorize_admin
    current_user.admin? || render(json: 'Only administrators can add books.', status: 401)
  end

end
