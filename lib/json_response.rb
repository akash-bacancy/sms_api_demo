# frozen_string_literal: true

class JsonResponse

  attr_reader :success, :message, :data, :meta, :errors

  def initialize(options = {})
    @success = options[:success]
    @message = options[:message] || ''
    @data = options[:data] || []
    @errors = options[:errors] || []
  end

  def as_json(*)
    {
      success: success,
      message: message,
      data: data,
      errors: errors
    }
  end

end