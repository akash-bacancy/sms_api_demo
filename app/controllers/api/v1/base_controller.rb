class Api::V1::BaseController < ApplicationController

  before_action :authenticate_user!


  protected

  def authenticate_user!
    username = request.headers['username']
    auth_id = request.headers['password']
    account = Account.find_by(username: username)
    if account.present?
      unauthenticated! unless account.auth_id == auth_id
    else
      unauthenticated!
    end
  end

  def unauthenticated!
    response.headers['WWW-Authenticate'] = 'Token realm=Application'
    json_response({ success: false, message: "Authentication failed"}, 403)
  end

end