require 'rails_helper'

RSpec.describe ProductScanner do
  let(:basket) { create(:basket) }
  let(:product) { create(:product, product_code: 'ABC') }
  let(:scanner) { ProductScanner.new(basket) }

  describe '#initialize' do
    it 'accepts a basket object on initialization' do
      expect { ProductScanner.new(basket) }.not_to raise_error
    end

    it 'stores the basket object' do
      expect(scanner.basket).to eq(basket)
    end
  end

  describe '#scan' do
    it 'responds to scan method' do
      expect(scanner).to respond_to(:scan)
    end

    it 'accepts a product code' do
      expect { scanner.scan(product.product_code) }.not_to raise_error
    end

    context 'when scanning a valid product code' do
      before do
        product
      end

      it 'adds the product as a basket item to the basket' do
        expect { scanner.scan(product.product_code) }.to change { basket.basket_items.count }.by(1)
      end

      it 'adds the correct product to the basket' do
        scanner.scan(product.product_code)
        expect(basket.basket_items.last.product).to eq(product)
      end

      it 'updates the quantity of basket items when scanning the same product multiple times' do
        scanner.scan(product.product_code)
        scanner.scan(product.product_code)

        expect(basket.basket_items.where(product:).count).to eq(1)
        expect(basket.basket_items.find_by(product:).quantity).to eq(2)
      end
    end

    context 'when scanning an invalid product code' do
      it 'handles gracefully' do
        expect { scanner.scan('INVALID') }.not_to raise_error
      end
    end
  end
end
