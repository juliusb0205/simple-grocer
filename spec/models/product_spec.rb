require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'validations' do
    describe 'product_code' do
      it 'is valid with a 3-character product code' do
        product = build(:product, product_code: 'ABC')
        expect(product).to be_valid
      end

      it 'returns an error when product code is less than 3 characters' do
        product = build(:product, product_code: 'AB')
        expect(product).not_to be_valid
        expect(product.errors[:product_code]).to include('must be exactly 3 characters')
      end

      it 'returns an error when product code is more than 3 characters' do
        product = build(:product, product_code: 'ABCD')
        expect(product).not_to be_valid
        expect(product.errors[:product_code]).to include('must be exactly 3 characters')
      end
    end
  end
end
