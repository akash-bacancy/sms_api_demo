class ApplicationController < ActionController::API



	include ApplicationMethods

	def handle_routes
	  begin
		rescue ActionController::RoutingError
		end
		json_response({ success: false, message: "URL not present."}, 405)			
	end
end
