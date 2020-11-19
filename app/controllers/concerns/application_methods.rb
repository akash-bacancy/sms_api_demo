# frozen_string_literal: true
module ApplicationMethods

  extend ActiveSupport::Concern



  private

  def render_success_response(resources = {}, message = '', status = 200, meta = {})
    json_response({
                    success: true,
                    message: message
                  }, status)
  end

  def json_response(options = {}, status = 500)
    render json: JsonResponse.new(options), status: status
  end

end
