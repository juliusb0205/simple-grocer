require 'rails_helper'

RSpec.describe Pricing::BasketBuyXLowestFreePricingStrategy do
  let(:basket) { create(:basket) }
  let(:offer) do
    offer = build(:offer, offer_type: :basket_buy_x_lowest_free)
    offer.offer_conditions.build(condition_type: 'minimum_items', condition_value: '3')
    offer.save!

    # Link products to the offer to make them eligible
    create(:product_offer, product: product_a, offer:)
    create(:product_offer, product: product_b, offer:)
    create(:product_offer, product: product_c, offer:)

    offer
  end
  let(:strategy) { described_class.new(basket, offer) }

  let(:product_a) { create(:product, price: Money.new(100)) } # $1.00
  let(:product_b) { create(:product, price: Money.new(200)) } # $2.00
  let(:product_c) { create(:product, price: Money.new(300)) } # $3.00

  describe '#conditions_met?' do
    context 'when basket has enough items' do
      before do
        create(:basket_item, basket:, product: product_a, quantity: 2, price: product_a.price * 2)
        create(:basket_item, basket:, product: product_b, quantity: 1, price: product_b.price)
      end

      it 'returns true' do
        expect(strategy.conditions_met?).to be true
      end
    end

    context 'when basket has insufficient items' do
      before do
        create(:basket_item, basket:, product: product_a, quantity: 1, price: product_a.price)
        create(:basket_item, basket:, product: product_b, quantity: 1, price: product_b.price)
      end

      it 'returns false' do
        expect(strategy.conditions_met?).to be false
      end
    end
  end

  describe '#apply!' do
    context 'with exactly minimum items' do
      before do
        create(:basket_item, basket:, product: product_a, quantity: 1, price: product_a.price)
        create(:basket_item, basket:, product: product_b, quantity: 1, price: product_b.price)
        create(:basket_item, basket:, product: product_c, quantity: 1, price: product_c.price)
      end

      it 'makes cheapest item free' do
        strategy.apply!

        cheapest_item = basket.basket_items.find_by(product: product_a)
        expect(cheapest_item.discount_amount).to eq(product_a.price)
        expect(cheapest_item.applied_offer).to eq(offer)
      end

      it 'does not discount other items' do
        strategy.apply!

        other_items = basket.basket_items.where(product: [ product_b, product_c ])
        expect(other_items.map(&:discount_amount)).to all(eq(Money.new(0)))
      end
    end

    context 'with multiple sets of minimum items' do
      before do
        create(:basket_item, basket:, product: product_a, quantity: 3, price: product_a.price * 3)
        create(:basket_item, basket:, product: product_b, quantity: 2, price: product_b.price * 2)
        create(:basket_item, basket:, product: product_c, quantity: 1, price: product_c.price)
      end

      it 'makes multiple cheapest items free' do
        strategy.apply!

        # Total items: 6, minimum: 3, so 2 free items
        # Should discount 2 units of product_a (cheapest)
        cheapest_item = basket.basket_items.find_by(product: product_a)
        expect(cheapest_item.discount_amount).to eq(product_a.price * 2)
        expect(cheapest_item.applied_offer).to eq(offer)
      end
    end

    context 'with mixed pricing scenarios' do
      before do
        # 4 items total: 1 at $3, 1 at $2, 2 at $1
        create(:basket_item, basket:, product: product_c, quantity: 1, price: product_c.price)
        create(:basket_item, basket:, product: product_b, quantity: 1, price: product_b.price)
        create(:basket_item, basket:, product: product_a, quantity: 2, price: product_a.price * 2)
      end

      it 'discounts cheapest individual items' do
        strategy.apply!

        # 4 items / 3 minimum = 1 free item
        # Should discount 1 unit of product_a
        cheapest_item = basket.basket_items.find_by(product: product_a)
        expect(cheapest_item.discount_amount).to eq(product_a.price)
      end
    end

    context 'when clearing previous discounts' do
      before do
        item = create(:basket_item, basket:, product: product_a, quantity: 1, price: product_a.price)
        item.update!(discount_amount_cents: 50, applied_offer: offer)

        create(:basket_item, basket:, product: product_b, quantity: 1, price: product_b.price)
        create(:basket_item, basket:, product: product_c, quantity: 1, price: product_c.price)
      end

      it 'clears existing discounts before applying new ones' do
        strategy.apply!

        item = basket.basket_items.find_by(product: product_a)
        expect(item.discount_amount).to eq(product_a.price) # Full discount, not partial
      end
    end
  end
end
