class Api::BaseController < ApplicationController
  protect_from_forgery with: :null_session

  before_action :authorize

  private

  def authorize
    @user = User.find_by_api_key(params[:api_key])
    # head will halt the HTTP request and send back the code you pass it.
    # in this case :unauthorized will send 401 HTTP response code
    # the body of the response will be empty
    head :unauthorized unless @user
  end
end
