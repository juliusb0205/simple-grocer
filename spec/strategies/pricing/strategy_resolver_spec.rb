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
      let(:offer) { create(:offer, :buy_x_take_y) }

      before do
        # Create product offer for other_product only
        create(:product_offer, product: other_product, offer:)
      end

      it 'returns DefaultPricingStrategy' do
        strategy = described_class.create(basket_item, offer)
        expect(strategy).to be_a(Pricing::DefaultPricingStrategy)
      end
    end

    context 'with buy_x_take_y offer' do
      let(:offer) { create(:offer, :buy_x_take_y) }

      before do
        create(:product_offer, product:, offer:)
      end

      context 'when conditions are met' do
        it 'returns BuyXTakeYPricingStrategy' do
          allow_any_instance_of(Pricing::BuyXTakeYPricingStrategy)
            .to receive(:conditions_met?).and_return(true)

          strategy = described_class.create(basket_item, offer)
          expect(strategy).to be_a(Pricing::BuyXTakeYPricingStrategy)
        end
      end

      context 'when conditions are not met' do
        it 'returns DefaultPricingStrategy' do
          allow_any_instance_of(Pricing::BuyXTakeYPricingStrategy)
            .to receive(:conditions_met?).and_return(false)

          strategy = described_class.create(basket_item, offer)
          expect(strategy).to be_a(Pricing::DefaultPricingStrategy)
        end
      end
    end

    context 'with quantity_discount_fixed_price offer' do
      let(:offer) { create(:offer, :quantity_discount_fixed_price) }

      before do
        create(:product_offer, product:, offer:)
      end

      context 'when conditions are met' do
        it 'returns QuantityDiscountFixedPricePricingStrategy' do
          allow_any_instance_of(Pricing::QuantityDiscountFixedPricePricingStrategy)
            .to receive(:conditions_met?).and_return(true)

          strategy = described_class.create(basket_item, offer)
          expect(strategy).to be_a(Pricing::QuantityDiscountFixedPricePricingStrategy)
        end
      end

      context 'when conditions are not met' do
        it 'returns DefaultPricingStrategy' do
          allow_any_instance_of(Pricing::QuantityDiscountFixedPricePricingStrategy)
            .to receive(:conditions_met?).and_return(false)

          strategy = described_class.create(basket_item, offer)
          expect(strategy).to be_a(Pricing::DefaultPricingStrategy)
        end
      end
    end

    context 'with quantity_discount_percentage_rate offer' do
      let(:offer) { create(:offer, :quantity_discount_percentage_rate) }

      before do
        create(:product_offer, product:, offer:)
      end

      context 'when conditions are met' do
        it 'returns QuantityDiscountPercentageRatePricingStrategy' do
          allow_any_instance_of(Pricing::QuantityDiscountPercentageRatePricingStrategy)
            .to receive(:conditions_met?).and_return(true)

          strategy = described_class.create(basket_item, offer)
          expect(strategy).to be_a(Pricing::QuantityDiscountPercentageRatePricingStrategy)
        end
      end

      context 'when conditions are not met' do
        it 'returns DefaultPricingStrategy' do
          allow_any_instance_of(Pricing::QuantityDiscountPercentageRatePricingStrategy)
            .to receive(:conditions_met?).and_return(false)

          strategy = described_class.create(basket_item, offer)
          expect(strategy).to be_a(Pricing::DefaultPricingStrategy)
        end
      end
    end
  end
end
