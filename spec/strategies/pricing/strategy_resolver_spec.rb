require 'rails_helper'

RSpec.describe Pricing::StrategyResolver do
  let(:product) { create(:product, price_cents: 250) }
  let(:basket) { create(:basket) }
  let(:basket_item) { create(:basket_item, basket:, product:, quantity: 2, price_cents: 100) }

  describe '.create' do
    context 'when offer is nil' do
      it 'returns DefaultPricingStrategy' do
        strategy = described_class.create(basket_item, nil)
        expect(strategy).to be_a(Pricing::DefaultPricingStrategy)
      end
    end

    context 'when offer does not apply to product' do
      let(:other_product) { create(:product) }
      let(:offer) { create(:offer, :buy_one_take_one) }

      before do
        # Create product offer for other_product only
        create(:product_offer, product: other_product, offer:)
      end

      it 'returns DefaultPricingStrategy' do
        strategy = described_class.create(basket_item, offer)
        expect(strategy).to be_a(Pricing::DefaultPricingStrategy)
      end
    end

    context 'with buy_one_take_one offer' do
      let(:offer) { create(:offer, :buy_one_take_one) }

      before do
        create(:product_offer, product:, offer:)
      end

      context 'when conditions are met' do
        it 'returns BuyOneTakeOnePricingStrategy' do
          allow_any_instance_of(Pricing::BuyOneTakeOnePricingStrategy)
            .to receive(:conditions_met?).and_return(true)

          strategy = described_class.create(basket_item, offer)
          expect(strategy).to be_a(Pricing::BuyOneTakeOnePricingStrategy)
        end
      end

      context 'when conditions are not met' do
        it 'returns DefaultPricingStrategy' do
          allow_any_instance_of(Pricing::BuyOneTakeOnePricingStrategy)
            .to receive(:conditions_met?).and_return(false)

          strategy = described_class.create(basket_item, offer)
          expect(strategy).to be_a(Pricing::DefaultPricingStrategy)
        end
      end
    end

    context 'with quantity_discount offer' do
      let(:offer) { create(:offer, :fixed_price_discount) }

      before do
        create(:product_offer, product:, offer:)
      end

      context 'when conditions are met' do
        it 'returns QuantityDiscountPricingStrategy' do
          allow_any_instance_of(Pricing::QuantityDiscountPricingStrategy)
            .to receive(:conditions_met?).and_return(true)

          strategy = described_class.create(basket_item, offer)
          expect(strategy).to be_a(Pricing::QuantityDiscountPricingStrategy)
        end
      end

      context 'when conditions are not met' do
        it 'returns DefaultPricingStrategy' do
          allow_any_instance_of(Pricing::QuantityDiscountPricingStrategy)
            .to receive(:conditions_met?).and_return(false)

          strategy = described_class.create(basket_item, offer)
          expect(strategy).to be_a(Pricing::DefaultPricingStrategy)
        end
      end
    end
  end
end
