require 'rails_helper'

RSpec.describe Pricing::BuyXTakeYPricingStrategy, type: :model do
  let(:product) { create(:product, price_cents: 250) }
  let(:basket) { create(:basket) }

  describe '#call' do
    context 'with buy 1 take 1 offer (base_quantity: 1, free_quantity: 1)' do
      let(:offer) { create(:offer, :buy_x_take_y, base_quantity: 1, free_quantity: 1) }

      context 'with quantity of 1' do
        let(:basket_item) { create(:basket_item, basket:, product:, quantity: 1, price_cents: 100) }
        let(:strategy) { Pricing::BuyXTakeYPricingStrategy.new(basket_item, offer) }

        it 'charges for 1 item' do
          expected_price = Money.new(250)
          expect(strategy.call).to eq(expected_price)
        end
      end

      context 'with quantity of 2' do
        let(:basket_item) { create(:basket_item, basket:, product:, quantity: 2, price_cents: 100) }
        let(:strategy) { Pricing::BuyXTakeYPricingStrategy.new(basket_item, offer) }

        it 'charges for 1 item (buy 1 take 1)' do
          expected_price = Money.new(250)
          expect(strategy.call).to eq(expected_price)
        end
      end

      context 'with quantity of 3' do
        let(:basket_item) { create(:basket_item, basket:, product:, quantity: 3, price_cents: 100) }
        let(:strategy) { Pricing::BuyXTakeYPricingStrategy.new(basket_item, offer) }

        it 'charges for 2 items' do
          expected_price = Money.new(500)
          expect(strategy.call).to eq(expected_price)
        end
      end

      context 'with quantity of 4' do
        let(:basket_item) { create(:basket_item, basket:, product:, quantity: 4, price_cents: 100) }
        let(:strategy) { Pricing::BuyXTakeYPricingStrategy.new(basket_item, offer) }

        it 'charges for 2 items' do
          expected_price = Money.new(500)
          expect(strategy.call).to eq(expected_price)
        end
      end

      context 'with quantity of 5' do
        let(:basket_item) { create(:basket_item, basket:, product:, quantity: 5, price_cents: 100) }
        let(:strategy) { Pricing::BuyXTakeYPricingStrategy.new(basket_item, offer) }

        it 'charges for 3 items' do
          expected_price = Money.new(750)
          expect(strategy.call).to eq(expected_price)
        end
      end
    end

    context 'with buy 2 take 1 offer (base_quantity: 2, free_quantity: 1)' do
      let(:offer) { create(:offer, :buy_x_take_y, base_quantity: 2, free_quantity: 1) }

      context 'with quantity of 2' do
        let(:basket_item) { create(:basket_item, basket:, product:, quantity: 2, price_cents: 100) }
        let(:strategy) { Pricing::BuyXTakeYPricingStrategy.new(basket_item, offer) }

        it 'charges for 2 items (not enough for promo)' do
          expected_price = Money.new(500)
          expect(strategy.call).to eq(expected_price)
        end
      end

      context 'with quantity of 3' do
        let(:basket_item) { create(:basket_item, basket:, product:, quantity: 3, price_cents: 100) }
        let(:strategy) { Pricing::BuyXTakeYPricingStrategy.new(basket_item, offer) }

        it 'charges for 2 items (buy 2 take 1)' do
          expected_price = Money.new(500)
          expect(strategy.call).to eq(expected_price)
        end
      end

      context 'with quantity of 6' do
        let(:basket_item) { create(:basket_item, basket:, product:, quantity: 6, price_cents: 100) }
        let(:strategy) { Pricing::BuyXTakeYPricingStrategy.new(basket_item, offer) }

        it 'charges for 4 items (2 sets of buy 2 take 1)' do
          expected_price = Money.new(1000)
          expect(strategy.call).to eq(expected_price)
        end
      end
    end

    context 'with buy 3 take 2 offer (base_quantity: 3, free_quantity: 2)' do
      let(:offer) { create(:offer, :buy_x_take_y, base_quantity: 3, free_quantity: 2) }

      context 'with quantity of 2' do
        let(:basket_item) { create(:basket_item, basket:, product:, quantity: 2, price_cents: 100) }
        let(:strategy) { Pricing::BuyXTakeYPricingStrategy.new(basket_item, offer) }

        it 'charges for 2 items (not enough for promo)' do
          expected_price = Money.new(500)
          expect(strategy.call).to eq(expected_price)
        end
      end

      context 'with quantity of 4' do
        let(:basket_item) { create(:basket_item, basket:, product:, quantity: 4, price_cents: 100) }
        let(:strategy) { Pricing::BuyXTakeYPricingStrategy.new(basket_item, offer) }

        it 'charges for 3 items (buy 3 get 1 free from the 2 available)' do
          expected_price = Money.new(750)
          expect(strategy.call).to eq(expected_price)
        end
      end

      context 'with quantity of 5' do
        let(:basket_item) { create(:basket_item, basket:, product:, quantity: 5, price_cents: 100) }
        let(:strategy) { Pricing::BuyXTakeYPricingStrategy.new(basket_item, offer) }

        it 'charges for 3 items (buy 3 take 2)' do
          expected_price = Money.new(750)
          expect(strategy.call).to eq(expected_price)
        end
      end

      context 'with quantity of 10' do
        let(:basket_item) { create(:basket_item, basket:, product:, quantity: 10, price_cents: 100) }
        let(:strategy) { Pricing::BuyXTakeYPricingStrategy.new(basket_item, offer) }

        it 'charges for 6 items (2 sets of buy 3 take 2)' do
          expected_price = Money.new(1500)
          expect(strategy.call).to eq(expected_price)
        end
      end
    end

    context 'with buy 1 take 3 offer (base_quantity: 1, free_quantity: 3)' do
      let(:offer) { create(:offer, :buy_x_take_y, base_quantity: 1, free_quantity: 3) }

      context 'with quantity of 1' do
        let(:basket_item) { create(:basket_item, basket:, product:, quantity: 1, price_cents: 100) }
        let(:strategy) { Pricing::BuyXTakeYPricingStrategy.new(basket_item, offer) }

        it 'charges for 1 item (buy 1, no free items yet)' do
          expected_price = Money.new(250)
          expect(strategy.call).to eq(expected_price)
        end
      end

      context 'with quantity of 2' do
        let(:basket_item) { create(:basket_item, basket:, product:, quantity: 2, price_cents: 100) }
        let(:strategy) { Pricing::BuyXTakeYPricingStrategy.new(basket_item, offer) }

        it 'charges for 1 item (buy 1 get 1 free)' do
          expected_price = Money.new(250)
          expect(strategy.call).to eq(expected_price)
        end
      end

      context 'with quantity of 4' do
        let(:basket_item) { create(:basket_item, basket:, product:, quantity: 4, price_cents: 100) }
        let(:strategy) { Pricing::BuyXTakeYPricingStrategy.new(basket_item, offer) }

        it 'charges for 1 item (buy 1 get 3 free)' do
          expected_price = Money.new(250)
          expect(strategy.call).to eq(expected_price)
        end
      end

      context 'with quantity of 5' do
        let(:basket_item) { create(:basket_item, basket:, product:, quantity: 5, price_cents: 100) }
        let(:strategy) { Pricing::BuyXTakeYPricingStrategy.new(basket_item, offer) }

        it 'charges for 2 items (1 complete set + 1 additional item)' do
          expected_price = Money.new(500)
          expect(strategy.call).to eq(expected_price)
        end
      end

      context 'with quantity of 8' do
        let(:basket_item) { create(:basket_item, basket:, product:, quantity: 8, price_cents: 100) }
        let(:strategy) { Pricing::BuyXTakeYPricingStrategy.new(basket_item, offer) }

        it 'charges for 2 items (2 complete sets of buy 1 take 3)' do
          expected_price = Money.new(500)
          expect(strategy.call).to eq(expected_price)
        end
      end
    end
  end
end
