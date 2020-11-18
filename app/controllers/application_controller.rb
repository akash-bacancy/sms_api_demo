class ApplicationController < ActionController::API

  rescue_from ActionController::RoutingError do
    json_response({ success: false, message: "URL not present."}, 405)
  end	
  
	include ApplicationMethods
end
