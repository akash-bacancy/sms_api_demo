class PhoneNumber < ApplicationRecord

	#associations
  belongs_to :account

	#validations
	validates :number, length: {minimum: 6, maximum: 16}
end
