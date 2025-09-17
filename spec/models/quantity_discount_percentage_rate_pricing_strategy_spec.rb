require 'rails_helper'

RSpec.describe Pricing::QuantityDiscountPercentageRatePricingStrategy, type: :model do
  let(:product) { create(:product, price_cents: 1123) }
  let(:basket) { create(:basket) }

  describe '#call' do
    context 'with percentage rate offer (minimum_quantity: 3, percentage_rate: 66.67)' do
      let(:offer) { create(:offer, :quantity_discount_percentage_rate, minimum_quantity: 3, percentage_rate: 66.67) }

      context 'with quantity below minimum' do
        let(:basket_item) { create(:basket_item, basket:, product:, quantity: 2, price_cents: 100) }
        let(:strategy) { Pricing::QuantityDiscountPercentageRatePricingStrategy.new(basket_item, offer) }

        it 'does not apply discount (conditions not met)' do
          expect(strategy.conditions_met?).to be false
        end
      end

      context 'with quantity equal to minimum' do
        let(:basket_item) { create(:basket_item, basket:, product:, quantity: 3, price_cents: 100) }
        let(:strategy) { Pricing::QuantityDiscountPercentageRatePricingStrategy.new(basket_item, offer) }

        it 'applies percentage rate discount' do
          # Original price: 11.23, Discount: 66.67% of original = 7.49
          # 1123 * 0.6667 = 749.0 per item * 3 = 2247 cents
          expected_price = Money.new(2247)
          expect(strategy.call).to eq(expected_price)
        end
      end

      context 'with quantity above minimum' do
        let(:basket_item) { create(:basket_item, basket:, product:, quantity: 5, price_cents: 100) }
        let(:strategy) { Pricing::QuantityDiscountPercentageRatePricingStrategy.new(basket_item, offer) }

        it 'applies percentage rate discount to all items' do
          # 749 cents per item * 5 = 3745 cents
          expected_price = Money.new(3745)
          expect(strategy.call).to eq(expected_price)
        end
      end
    end

    context 'with different percentage rate offer (minimum_quantity: 2, percentage_rate: 50.0)' do
      let(:offer) { create(:offer, :quantity_discount_percentage_rate, minimum_quantity: 2, percentage_rate: 50.0) }

      context 'with minimum quantity' do
        let(:basket_item) { create(:basket_item, basket:, product:, quantity: 2, price_cents: 100) }
        let(:strategy) { Pricing::QuantityDiscountPercentageRatePricingStrategy.new(basket_item, offer) }

        it 'applies 50% discount' do
          # Original price: 11.23, 50% discount = 5.615, rounded = 562 cents per item * 2 = 1124 cents
          expected_price = Money.new(1124)
          expect(strategy.call).to eq(expected_price)
        end
      end
    end

    context 'with 75% discount offer' do
      let(:offer) { create(:offer, :quantity_discount_percentage_rate, minimum_quantity: 1, percentage_rate: 75.0) }

      context 'with single item' do
        let(:basket_item) { create(:basket_item, basket:, product:, quantity: 1, price_cents: 100) }
        let(:strategy) { Pricing::QuantityDiscountPercentageRatePricingStrategy.new(basket_item, offer) }

        it 'applies 75% discount' do
          expected_price = Money.new((1123 * 0.75).round)
          expect(strategy.call).to eq(expected_price)
        end
      end
    end
  end
end
