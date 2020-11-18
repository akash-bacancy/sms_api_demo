class Api::SmsSenderController < Api::BaseController

	before_action :validate_params_presence
	before_action :validate_params_length

	
	def inbound_sms
		unless find_number(params[:to])
			json_response({success: false, message: "Number not found"}, 404)
			return false
		end
		key = Time.now.to_i
		# if ["STOP", "STOP\n", "STOP\r\n"].include? params[:text]
		if params[:text].match(/STOP/)
			Rails.cache.write(key, {'from': params[:from], 'to': params[:to]}, expires_in: 4.hours)
			unique_keys = Rails.cache.read("number_keys").present? ? Rails.cache.read("number_keys") : []
			unique_keys.push(key) 
			Rails.cache.write("number_keys", unique_keys)
			count = Rails.cache.read(params[:from]).present? ? Rails.cache.read(params[:from]) : 0
			Rails.cache.write(params[:from], count+1, expires_in: 1.minute)
		end
		render_success_response({}, 'Inbound sms ok', 200)
	end

	def outbound_sms
		unless find_number(params[:from])
			json_response({success: false, message: "Number not found"}, 404)
			return false
		end
		number_keys = Rails.cache.read('number_keys')
		if number_keys.present?
			number_keys.each do |x|
				from_to = Rails.cache.read(x)
				count = Rails.cache.read(params[:from]).present? ? Rails.cache.read(params[:from]) : 0
				if count >= 5
					json_response({success: false, message: "limit reached for from #{params[:from]}"})
					return false
				end
				return false if validate_outbound_sms(from_to) == false
			end
			render_success_response({}, 'Outbound sms ok', 200)
		else
			render_success_response({}, 'Outbound sms ok', 200)
		end
	end

	def validate_outbound_sms from_to
		if (from_to[:from] == params[:from] && from_to[:to] == params[:to])
			json_response({success: false, message: "sms from #{from_to[:from]} to #{from_to[:to]} blocked by STOP request"})
			false
		end
	end


	private

	def validate_params_presence
		a = []
		%w( from to text ).each{ |key| a.push(key) unless params[key].present? }
		if a.present?
			json_response({success: false, message: "#{a.map(&:humanize).join(', ')} - are missing"})
			return false
		end
	end

	def validate_params_length
		a = []
		%w(from to).each{ |key| a.push(key) unless params[key].to_s.length.between?(6,16) }
		if a.present?
			json_response({success: false, message: "#{a.map(&:humanize).join(', ')} - are invalid"})
			return false
		end	
	end

	def find_number(num)
		PhoneNumber.find_by(number: num)
	end
end
