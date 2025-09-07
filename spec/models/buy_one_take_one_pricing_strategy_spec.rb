require 'rails_helper'

RSpec.describe Pricing::BuyOneTakeOnePricingStrategy, type: :model do
  let(:product) { create(:product, price_cents: 250) }
  let(:basket) { create(:basket) }
  let(:offer) { create(:offer, :buy_one_take_one) }

  describe '#call' do
    context 'with quantity of 1' do
      let(:basket_item) { create(:basket_item, basket:, product:, quantity: 1, price_cents: 100) }
      let(:strategy) { Pricing::BuyOneTakeOnePricingStrategy.new(basket_item, offer) }

      it 'charges for 1 item' do
        expected_price = Money.new(250)
        expect(strategy.call).to eq(expected_price)
      end
    end

    context 'with quantity of 2' do
      let(:basket_item) { create(:basket_item, basket:, product:, quantity: 2, price_cents: 100) }
      let(:strategy) { Pricing::BuyOneTakeOnePricingStrategy.new(basket_item, offer) }

      it 'charges for 1 item (buy 1 take 1)' do
        expected_price = Money.new(250)
        expect(strategy.call).to eq(expected_price)
      end
    end

    context 'with quantity of 3' do
      let(:basket_item) { create(:basket_item, basket:, product:, quantity: 3, price_cents: 100) }
      let(:strategy) { Pricing::BuyOneTakeOnePricingStrategy.new(basket_item, offer) }

      it 'charges for 2 items' do
        expected_price = Money.new(500)
        expect(strategy.call).to eq(expected_price)
      end
    end

    context 'with quantity of 4' do
      let(:basket_item) { create(:basket_item, basket:, product:, quantity: 4, price_cents: 100) }
      let(:strategy) { Pricing::BuyOneTakeOnePricingStrategy.new(basket_item, offer) }

      it 'charges for 2 items' do
        expected_price = Money.new(500)
        expect(strategy.call).to eq(expected_price)
      end
    end

    context 'with quantity of 5' do
      let(:basket_item) { create(:basket_item, basket:, product:, quantity: 5, price_cents: 100) }
      let(:strategy) { Pricing::BuyOneTakeOnePricingStrategy.new(basket_item, offer) }

      it 'charges for 3 items' do
        expected_price = Money.new(750)
        expect(strategy.call).to eq(expected_price)
      end
    end
  end
end
