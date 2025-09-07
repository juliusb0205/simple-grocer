class ProductScanner
  attr_reader :basket

  def initialize(basket)
    @basket = basket
  end

  def scan(product_code)
    product = Product.find_by(product_code:)
    return false unless product

    basket_item = add_product_to_basket(product)
    calculate_basket_item_price(basket_item)

    true
  end

  private

  def add_product_to_basket(product)
    existing_item = basket.basket_items.find_by(product:)

    if existing_item
      existing_item.tap do |item|
        item.quantity += 1
        item.price_cents = product.price_cents * item.quantity
        item.save!
      end
    else
      basket.basket_items.create!(product:, quantity: 1, price_cents: product.price_cents)
    end
  end

  def calculate_basket_item_price(basket_item)
    basket_item.update!(price_cents: basket_item.product.price_cents * basket_item.quantity)
  end
end
