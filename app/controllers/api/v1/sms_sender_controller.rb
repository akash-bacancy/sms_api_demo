class Api::V1::SmsSenderController < Api::V1::BaseController

  before_action :validate_params_presence
  before_action :validate_params_length

  LIMIT = 50
  
  def inbound_sms
    unless find_number(params[:to])
      json_response({success: false, message: "Number not found"}, 404)
      return false
    end
    
    if params[:text].match(/STOP/)
      #add values for cache for from-to numbers
      add_from_to_cache
      #update limit of count for from number
      update_limit
    end
    success_response 'Inbound'
  end

  def outbound_sms
    unless find_number(params[:from])
      json_response({success: false, message: "Number not found"}, 404)
      return false
    end
    number_keys = Rails.cache.read('number_keys')
    if number_keys.present?
      number_keys.each do |time|
        from_to = Rails.cache.read(time)

        #update unique keys after expire
        number_keys.delete(time) if from_to.blank?
        Rails.cache.write('number_keys', number_keys)
        return false if check_sms_limit?(time)
        return false if validate_outbound_sms?(from_to)
      end
    end
    success_response "Outbound"
  end

  def validate_outbound_sms?(from_to)
    if from_to.present? && (from_to[:from] == params[:from] && from_to[:to] == params[:to])
      json_response({success: false, message: "sms from #{from_to[:from]} to #{from_to[:to]} blocked by STOP request"}, 400)
      true
    else
      false
    end
  end

  def check_sms_limit?(unique_ts)
    from_to = Rails.cache.read(unique_ts)
    count = Rails.cache.read(params[:from]).present? ? Rails.cache.read(params[:from]) : 0
    if count >= LIMIT
      json_response({success: false, message: "limit reached for from #{params[:from]}"}, 400)
      true
    else
      false
    end
  end

  def update_limit
    count = Rails.cache.read(params[:from]).present? ? Rails.cache.read(params[:from]) : 0
    Rails.cache.write(params[:from], count+1, expires_in: 24.hours)   
  end

  def add_from_to_cache
    key = Time.now.to_i
    Rails.cache.write(key, {'from': params[:from], 'to': params[:to]}, expires_in: 4.hours)
    unique_keys = Rails.cache.read("number_keys").present? ? Rails.cache.read("number_keys") : []
    unique_keys.push(key) 
    Rails.cache.write("number_keys", unique_keys)
  end


  private

  def validate_params_presence
    missing_params = []
    %w( from to text ).each{ |key| missing_params.push(key) unless params[key].present? }
    if missing_params.present?
      json_response({success: false, message: "#{missing_params.map(&:humanize).join(', ')} - are missing"}, 400)
      return false
    end
  end

  def validate_params_length
    invalid_params = []
    %w(from to).each{ |key| invalid_params.push(key) unless params[key].to_s.length.between?(6,16) }
    if invalid_params.present?
      json_response({success: false, message: "#{invalid_params.map(&:humanize).join(', ')} - are invalid"}, 400)
      return false
    end 
  end

  def find_number(num)
    PhoneNumber.find_by(number: num)
  end

  def success_response message
    render_success_response({}, "#{message} sms ok", 201)
  end
end
