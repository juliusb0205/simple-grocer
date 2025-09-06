require 'rails_helper'

RSpec.describe BasketItem, type: :model do
  describe 'validations' do
    it { should validate_numericality_of(:quantity).only_integer.is_greater_than(0) }
  end
end
