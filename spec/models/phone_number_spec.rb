require 'rails_helper'

RSpec.describe PhoneNumber, type: :model do
  
  describe 'associations' do
    it { should belong_to :account }
  end
end
