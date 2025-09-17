require 'rails_helper'

RSpec.describe Offer, type: :model do
  describe 'associations' do
    it { should have_many(:product_offers).dependent(:destroy) }
    it { should have_many(:products).through(:product_offers) }
    it { should have_many(:offer_conditions).dependent(:destroy) }
  end

  describe 'enums' do
    it { should define_enum_for(:offer_type).with_values(buy_x_take_y: 0, quantity_discount: 1) }
  end

  describe 'validations' do
    describe 'name validation' do
      it 'requires name to be present' do
        offer = build(:offer, name: nil)
        expect(offer).not_to be_valid
        expect(offer.errors[:name]).to include("can't be blank")
      end

      it 'requires name to be unique' do
        create(:offer, name: 'Unique Offer')
        offer = build(:offer, name: 'Unique Offer')
        expect(offer).not_to be_valid
        expect(offer.errors[:name]).to include("has already been taken")
      end
    end

    describe 'offer_type validation' do
      it 'requires offer_type to be present' do
        offer = build(:offer, offer_type: nil)
        expect(offer).not_to be_valid
        expect(offer.errors[:offer_type]).to include("can't be blank")
      end
    end

    describe 'required conditions validation' do
      context 'when offer_type is buy_x_take_y' do
        it 'cannot be saved without base_quantity and free_quantity conditions' do
          offer = build(:offer, offer_type: :buy_x_take_y)
          offer.offer_conditions.clear
          expect(offer.save).to be_falsey
          expect(offer.errors[:offer_conditions]).to include('Missing required conditions: base_quantity, free_quantity')
        end

        it 'is valid when built with required conditions via factory' do
          offer = create(:offer, :buy_x_take_y)
          expect(offer).to be_valid
          expect(offer.offer_conditions.find_by(condition_type: 'base_quantity')).to be_present
          expect(offer.offer_conditions.find_by(condition_type: 'free_quantity')).to be_present
        end
      end

      context 'when offer_type is quantity_discount' do
        it 'cannot be saved without minimum_quantity condition' do
          offer = build(:offer, offer_type: :quantity_discount)
          expect(offer.save).to be_falsey
          expect(offer.errors[:offer_conditions]).to include('Missing required conditions: minimum_quantity')
        end

        it 'is valid when built with required condition via factory' do
          offer = create(:offer, :quantity_discount)
          expect(offer).to be_valid
          expect(offer.offer_conditions.find_by(condition_type: 'minimum_quantity')).to be_present
        end

        it 'can be saved with minimum_quantity condition built before save' do
          offer = build(:offer, offer_type: :quantity_discount)
          offer.offer_conditions.build(condition_type: 'minimum_quantity', condition_value: '5')
          expect(offer.save).to be_truthy
          expect(offer).to be_valid
        end

        it 'is invalid when destroying required condition from existing offer' do
          offer = create(:offer, :quantity_discount)
          condition = offer.offer_conditions.find_by(condition_type: 'minimum_quantity')
          condition.destroy!

          expect(offer.reload.valid?).to be_falsey
          expect(offer.errors[:offer_conditions]).to include('Missing required conditions: minimum_quantity')
        end
      end

      context 'when changing offer_type' do
        it 'cannot be saved when changing to quantity_discount without required condition' do
          offer = create(:offer, offer_type: :buy_x_take_y)
          offer.offer_type = :quantity_discount

          expect(offer.save).to be_falsey
          expect(offer.errors[:offer_conditions]).to include('Missing required conditions: minimum_quantity')
        end

        it 'can be saved when changing offer_type and conditions are present' do
          offer = create(:offer, offer_type: :buy_x_take_y)
          offer.offer_conditions.create!(condition_type: 'minimum_quantity', condition_value: '3')
          offer.offer_type = :quantity_discount

          expect(offer.save).to be_truthy
          expect(offer).to be_valid
        end
      end
    end
  end
end
