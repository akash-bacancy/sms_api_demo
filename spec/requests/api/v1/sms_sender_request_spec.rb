require 'rails_helper'

RSpec.describe "Api::V1::SmsSenders", type: :request do

  describe "POST /api/v1/inbound/sms/" do

    before do
      post '/api/v1/inbound/sms', params: { :from => '61871112931', :to => '61871112939', :text => 'Hello, world'},headers: { :password => "20S0KPNOIM", :username => "azr1" }
    end

    it 'returns a created status' do
      expect(response).to have_http_status(:created)
    end

    context "with invalid credentials" do
      before do
        post '/api/v1/inbound/sms', params: { :from => '61871112931', :to => '61871112939', :text => 'Hello, world'},headers: { :password => "20S0KPNOIM0", :username => "azr10" }
      end

      it 'returns a 403 forbidden status' do
        expect(response).to have_http_status(:forbidden)
      end     
    end   

    context "with invalid parameters" do
      before do
        post '/api/v1/inbound/sms', params: { :from => '61871112931', :to => '61871112939', :text => 'Hello, world'},headers: { :password => "20S0KPNOIM", :username => "azr1" }
      end
      it 'returns a 400 bad request status' do
        expect(response).to have_http_status(:bad_request)
      end     
    end

    context "with missing parameters" do
      before do
        post '/api/v1/inbound/sms', params: { :to => '1212', :text => 'Hello, world'},headers: { :password => "20S0KPNOIM", :username => "azr1" }
      end
      it 'returns a 400 bad request status' do
        expect(response).to have_http_status(:bad_request)
      end     
    end

  end

  describe "POST /api/v1/outbound/sms/" do

    before do
      post '/api/v1/outbound/sms', params: { :from => '61871112940', :to => '61871112939', :text => 'Hello, world'},headers: { :password => "20S0KPNOIM", :username => "azr1" }
    end

    it 'returns a created status' do
      expect(response).to have_http_status(:created)
    end

    context "with invalid credentials" do
      before do
        post '/api/v1/inbound/sms', params: { :from => '3434444444444444444', :to => '1212', :text => 'Hello, world'},headers: { :password => "20S0KPNOIM0", :username => "azr10" }
      end

      it 'returns a 403 forbidden status' do
        expect(response).to have_http_status(:forbidden)
      end     
    end 

    context "with invalid parameters" do
      before do
        post '/api/v1/outbound/sms', params: { :from => '1212', :to => '1212', :text => 'test_service'},headers: { :password => "20S0KPNOIM", :username => "azr1" }
      end
      it 'returns a 400 bad request status' do
        expect(response).to have_http_status(:bad_request)
      end     
    end

    context "with missing parameters" do
      before do
        post '/api/v1/outbound/sms', params: { :to => '1212', :text => 'test_service'},headers: { :password => "20S0KPNOIM", :username => "azr1" }
      end
      it 'returns a 400 bad request status' do
        expect(response).to have_http_status(:bad_request)
      end     
    end
  end
end