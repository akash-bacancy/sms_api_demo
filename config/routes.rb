Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      post '/inbound/sms/', to: 'sms_sender#inbound_sms'
      post '/outbound/sms/', to: 'sms_sender#outbound_sms'
      # match "/404", :to => "application#internal_server_error", :via => :all
    end
  end
  match '*unmatched', to: 'application#handle_routes', via: :all
end
