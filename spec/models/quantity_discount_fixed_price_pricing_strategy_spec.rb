require 'rails_helper'

RSpec.describe Pricing::QuantityDiscountFixedPricePricingStrategy, type: :model do
  let(:product) { create(:product, price_cents: 500) }
  let(:basket) { create(:basket) }

  describe '#call' do
    context 'with fixed price offer (minimum_quantity: 3, fixed_price: 4.50)' do
      let(:offer) { create(:offer, :quantity_discount_fixed_price, minimum_quantity: 3, fixed_price: 4.50) }

      context 'with quantity below minimum' do
        let(:basket_item) { create(:basket_item, basket:, product:, quantity: 2, price_cents: 100) }
        let(:strategy) { Pricing::QuantityDiscountFixedPricePricingStrategy.new(basket_item, offer) }

        it 'does not apply discount (conditions not met)' do
          expect(strategy.conditions_met?).to be false
        end
      end

      context 'with quantity equal to minimum' do
        let(:basket_item) { create(:basket_item, basket:, product:, quantity: 3, price_cents: 100) }
        let(:strategy) { Pricing::QuantityDiscountFixedPricePricingStrategy.new(basket_item, offer) }

        it 'applies fixed price discount' do
          expected_price = Money.new(450 * 3) # 4.50 each for 3 items
          expect(strategy.call).to eq(expected_price)
        end
      end

      context 'with quantity above minimum' do
        let(:basket_item) { create(:basket_item, basket:, product:, quantity: 5, price_cents: 100) }
        let(:strategy) { Pricing::QuantityDiscountFixedPricePricingStrategy.new(basket_item, offer) }

        it 'applies fixed price discount to all items' do
          expected_price = Money.new(450 * 5) # 4.50 each for 5 items
          expect(strategy.call).to eq(expected_price)
        end
      end
    end

    context 'with different fixed price offer (minimum_quantity: 2, fixed_price: 3.00)' do
      let(:offer) { create(:offer, :quantity_discount_fixed_price, minimum_quantity: 2, fixed_price: 3.00) }

      context 'with minimum quantity' do
        let(:basket_item) { create(:basket_item, basket:, product:, quantity: 2, price_cents: 100) }
        let(:strategy) { Pricing::QuantityDiscountFixedPricePricingStrategy.new(basket_item, offer) }

        it 'applies fixed price discount' do
          expected_price = Money.new(300 * 2) # 3.00 each for 2 items
          expect(strategy.call).to eq(expected_price)
        end
      end
    end
  end
end
