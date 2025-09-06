require 'rails_helper'

RSpec.describe Offer, type: :model do
  describe 'associations' do
    it { should have_many(:product_offers).dependent(:destroy) }
    it { should have_many(:products).through(:product_offers) }
  end

  describe 'enums' do
    it { should define_enum_for(:discount_type).with_values(buy_one_take_one: 0, quantity_discount: 1) }
    it { should define_enum_for(:rate_type).with_values(fixed_price: 0, percentage_rate: 1) }
  end

  describe 'validations' do
    context 'when discount_type is buy_one_take_one' do
      let(:offer) { build(:offer, discount_type: :buy_one_take_one) }

      it 'allows all nullable fields to be blank' do
        offer.rate_type = nil
        offer.percentage_rate = nil
        offer.fixed_price_cents = nil
        offer.minimum_quantity = nil

        expect(offer).to be_valid
      end
    end

    context 'when discount_type is quantity_discount' do
      let(:offer) { build(:offer, discount_type: :quantity_discount) }

      it 'requires rate_type to be present' do
        offer.rate_type = nil
        expect(offer).not_to be_valid
        expect(offer.errors[:rate_type]).to include("can't be blank")
      end

      context 'and rate_type is fixed_price' do
        it 'requires fixed_price_cents to be present' do
          offer.rate_type = :fixed_price
          offer.fixed_price_cents = nil

          expect(offer).not_to be_valid
          expect(offer.errors[:fixed_price_cents]).to include("can't be blank")
        end

        it 'is valid with fixed_price_cents present' do
          offer.rate_type = :fixed_price
          offer.fixed_price_cents = 100

          expect(offer).to be_valid
        end
      end

      context 'and rate_type is percentage_rate' do
        it 'requires percentage_rate to be present' do
          offer.rate_type = :percentage_rate
          offer.percentage_rate = nil

          expect(offer).not_to be_valid
          expect(offer.errors[:percentage_rate]).to include("can't be blank")
        end

        it 'is valid with percentage_rate present' do
          offer.rate_type = :percentage_rate
          offer.percentage_rate = 10.5

          expect(offer).to be_valid
        end

        it 'validates percentage_rate is between 0 and 100' do
          offer.rate_type = :percentage_rate

          offer.percentage_rate = -1
          expect(offer).not_to be_valid

          offer.percentage_rate = 101
          expect(offer).not_to be_valid

          offer.percentage_rate = 50
          expect(offer).to be_valid
        end
      end
    end

    describe 'name validation' do
      it 'requires name to be present' do
        offer = build(:offer, name: nil)
        expect(offer).not_to be_valid
        expect(offer.errors[:name]).to include("can't be blank")
      end
    end

    describe 'discount_type validation' do
      it 'requires discount_type to be present' do
        offer = build(:offer, discount_type: nil)
        expect(offer).not_to be_valid
        expect(offer.errors[:discount_type]).to include("can't be blank")
      end
    end

    describe 'minimum_quantity validation for quantity_discount' do
      let(:offer) { build(:offer, discount_type: :quantity_discount, rate_type: :percentage_rate, percentage_rate: 10) }

      it 'requires minimum_quantity to be present' do
        offer.minimum_quantity = nil

        expect(offer).not_to be_valid
        expect(offer.errors[:minimum_quantity]).to include("can't be blank")
      end

      it 'requires minimum_quantity to be greater than 1' do
        offer.minimum_quantity = 0
        expect(offer).not_to be_valid

        offer.minimum_quantity = 1
        expect(offer).not_to be_valid

        offer.minimum_quantity = 2
        expect(offer).to be_valid
      end
    end
  end
end
