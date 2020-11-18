# frozen_string_literal: true

class JsonResponse

  attr_reader :success, :message

  def initialize(options = {})
    @success = options[:success]
    @message = options[:message] || ''
  end

  def as_json(*)
    {
      success: success,
      message: message
    }
  end

end
