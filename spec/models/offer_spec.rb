require 'rails_helper'

RSpec.describe Offer, type: :model do
  describe 'associations' do
    it { should have_many(:product_offers).dependent(:destroy) }
    it { should have_many(:products).through(:product_offers) }
  end

  describe 'enums' do
    it { should define_enum_for(:offer_type).with_values(buy_one_take_one: 0, quantity_discount: 1) }
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
  end
end
