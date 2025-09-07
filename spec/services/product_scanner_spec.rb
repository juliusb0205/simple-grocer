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

      it 'returns true when successfully adding product' do
        expect(scanner.scan(product.product_code)).to be true
      end

      it 'adds the product as a basket item to the basket' do
        expect { scanner.scan(product.product_code) }.to change { basket.basket_items.count }.by(1)
      end

      it 'adds the correct product to the basket' do
        scanner.scan(product.product_code)
        expect(basket.basket_items.last.product).to eq(product)
      end

      it 'returns true when updating quantity of existing product' do
        scanner.scan(product.product_code)
        expect(scanner.scan(product.product_code)).to be true
      end

      it 'updates the quantity of basket items when scanning the same product multiple times' do
        scanner.scan(product.product_code)

        expect { scanner.scan(product.product_code) }.to change { basket.basket_items.where(product:).count }.by(0)
        expect { scanner.scan(product.product_code) }.to change { basket.basket_items.find_by(product:).quantity }.by(1)
      end

      it 'sets the correct price when adding a new product' do
        scanner.scan(product.product_code)
        basket_item = basket.basket_items.find_by(product:)
        expect(basket_item.price_cents).to eq(product.price_cents * 1)
      end

      it 'updates the price when increasing quantity of existing product' do
        scanner.scan(product.product_code)
        initial_price = basket.basket_items.find_by(product:).price_cents

        scanner.scan(product.product_code)
        updated_basket_item = basket.basket_items.find_by(product:)

        expect(updated_basket_item.price_cents).to eq(product.price_cents * updated_basket_item.quantity)
        expect(updated_basket_item.price_cents).to be > initial_price
      end

      context 'with different priced products' do
        let(:expensive_product) { create(:product, product_code: 'EXP', price_cents: 2500) }
        let(:cheap_product) { create(:product, product_code: 'CHP', price_cents: 500) }

        it 'calculates correct prices for different products' do
          scanner.scan(expensive_product.product_code)
          scanner.scan(cheap_product.product_code)

          expensive_item = basket.basket_items.find_by(product: expensive_product)
          cheap_item = basket.basket_items.find_by(product: cheap_product)

          expect(expensive_item.price_cents).to eq(2500)
          expect(cheap_item.price_cents).to eq(500)
        end

        it 'calculates correct total price when scanning multiple quantities' do
          3.times { scanner.scan(expensive_product.product_code) }
          2.times { scanner.scan(cheap_product.product_code) }

          expensive_item = basket.basket_items.find_by(product: expensive_product)
          cheap_item = basket.basket_items.find_by(product: cheap_product)

          expect(expensive_item.quantity).to eq(3)
          expect(expensive_item.price_cents).to eq(2500 * 3)
          expect(cheap_item.quantity).to eq(2)
          expect(cheap_item.price_cents).to eq(500 * 2)
        end
      end
    end

    context 'when scanning an invalid product code' do
      it 'returns false' do
        expect(scanner.scan('INVALID')).to be false
      end

      it 'handles gracefully' do
        expect { scanner.scan('INVALID') }.not_to raise_error
      end
    end
  end
end
