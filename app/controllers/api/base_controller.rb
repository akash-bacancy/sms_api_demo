class Api::BaseController < ApplicationController


  before_action :authenticate_user

  protected

  def authenticate_user
    username = request.headers['username']
    auth_id = request.headers['password']
    account = Account.find_by(username: username)
    if account.present?
      json_response({ success: false, message: "Authentication failed"}, 403) unless account.auth_id == auth_id
    else
      json_response({ success: false, message: "Account not found."}, 404)
    end
  end

end