FactoryBot.define do
  factory :phone_number do
  	association :account
    number {'12345671'}
  end
end
