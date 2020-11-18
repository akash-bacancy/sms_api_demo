require 'rails_helper'

RSpec.describe "Api::V1::SmsSenders", type: :request do
  describe "POST /api/v1/inbound/sms/" do

		before do
		  post '/api/v1/inbound/sms', params: { :from => '61871112931', :to => '61871112939', :text => 'test_service'},headers: { :password => "20S0KPNOIM", :username => "azr1" }
		end

		it 'returns a created status' do
		  expect(response).to have_http_status(:created)
		end

    context "with invalid parameters" do

    end
  end

  describe "POST /api/v1/outbound/sms/" do

		before do
		  post '/api/v1/outbound/sms', params: { :from => '61871112940', :to => '61871112939', :text => 'test_service'},headers: { :password => "20S0KPNOIM", :username => "azr1" }
		end

		it 'returns a created status' do
		  expect(response).to have_http_status(:created)
		end

    context "with invalid parameters" do

    end
  end
end