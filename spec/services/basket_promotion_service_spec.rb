require 'rails_helper'

RSpec.describe BasketPromotionService do
  let(:basket) { create(:basket) }
  let(:product_a) { create(:product, price: Money.new(100)) } # $1.00
  let(:product_b) { create(:product, price: Money.new(200)) } # $2.00
  let(:product_c) { create(:product, price: Money.new(300)) } # $3.00
  let(:service) { described_class.new(basket) }

  describe '#apply_promotions!' do
    context 'with basket_buy_x_lowest_free offer' do
      let!(:offer) do
        offer = build(:offer, offer_type: :basket_buy_x_lowest_free)
        offer.offer_conditions.build(condition_type: 'minimum_items', condition_value: '3')
        offer.save!

        # Link products to the offer to make them eligible
        create(:product_offer, product: product_a, offer:)
        create(:product_offer, product: product_b, offer:)
        create(:product_offer, product: product_c, offer:)

        offer
      end

      context 'when basket has exactly minimum items' do
        before do
          create(:basket_item, basket:, product: product_a, quantity: 1, price: product_a.price)
          create(:basket_item, basket:, product: product_b, quantity: 1, price: product_b.price)
          create(:basket_item, basket:, product: product_c, quantity: 1, price: product_c.price)
        end

        it 'applies discount to cheapest item' do
          service.apply_promotions!

          cheapest_item = basket.basket_items.find_by(product: product_a)
          expect(cheapest_item.discount_amount).to eq(product_a.price)
          expect(cheapest_item.applied_offer).to eq(offer)
        end

        it 'does not apply discount to other items' do
          service.apply_promotions!

          other_items = basket.basket_items.where(product: [ product_b, product_c ])
          expect(other_items.map(&:discount_amount)).to all(eq(Money.new(0)))
        end
      end

      context 'when basket has more than minimum items' do
        before do
          create(:basket_item, basket:, product: product_a, quantity: 2, price: product_a.price * 2)
          create(:basket_item, basket:, product: product_b, quantity: 2, price: product_b.price * 2)
          create(:basket_item, basket:, product: product_c, quantity: 2, price: product_c.price * 2)
        end

        it 'applies multiple discounts for multiple sets' do
          service.apply_promotions!

          # Total items: 6, minimum: 3, so 2 free items
          # Both free items should be from the cheapest product (product_a)
          discounted_items = basket.basket_items.where.not(discount_amount_cents: 0)
          expect(discounted_items.count).to eq(1)

          # Should discount cheapest items (product_a twice)
          product_a_item = basket.basket_items.find_by(product: product_a)
          expect(product_a_item.discount_amount).to eq(product_a.price * 2)
        end
      end

      context 'when basket has less than minimum items' do
        before do
          create(:basket_item, basket:, product: product_a, quantity: 1, price: product_a.price)
          create(:basket_item, basket:, product: product_b, quantity: 1, price: product_b.price)
        end

        it 'does not apply any discount' do
          service.apply_promotions!

          expect(basket.basket_items.map(&:discount_amount)).to all(eq(Money.new(0)))
        end
      end

      context 'when items have same price' do
        let(:product_d) { create(:product, price: Money.new(100)) } # Same as product_a

        before do
          # Link product_d to the offer to make it eligible
          create(:product_offer, product: product_d, offer:)

          create(:basket_item, basket:, product: product_a, quantity: 1, price: product_a.price)
          create(:basket_item, basket:, product: product_d, quantity: 1, price: product_d.price)
          create(:basket_item, basket:, product: product_b, quantity: 1, price: product_b.price)
        end

        it 'applies discount to first cheapest item found' do
          service.apply_promotions!

          discounted_items = basket.basket_items.where.not(discount_amount_cents: 0)
          expect(discounted_items.count).to eq(1)
          expect(discounted_items.first.product.price).to eq(Money.new(100))
        end
      end
    end

    context 'without applicable offers' do
      before do
        create(:basket_item, basket:, product: product_a, quantity: 1, price: product_a.price)
      end

      it 'does not apply any discounts' do
        service.apply_promotions!

        expect(basket.basket_items.map(&:discount_amount)).to all(eq(Money.new(0)))
      end
    end
  end
end
