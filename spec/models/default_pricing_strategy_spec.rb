require 'rails_helper'

RSpec.describe DefaultPricingStrategy, type: :model do
  let(:product) { create(:product, price_cents: 250) }
  let(:basket) { create(:basket) }
  let(:basket_item) { create(:basket_item, basket:, product:, quantity: 3, price_cents: 100) }
  let(:offer) { create(:offer) }
  let(:strategy) { DefaultPricingStrategy.new(basket_item, offer) }

  describe '#call' do
    it 'returns the correct price calculation' do
      expected_price = Money.new(750)

      expect(strategy.call).to eq(expected_price)
    end

    it 'multiplies quantity by product price' do
      expect(strategy.call).to eq(basket_item.quantity * basket_item.product.price)
    end
  end
end
