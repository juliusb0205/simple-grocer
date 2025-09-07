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
        item.price_cents = DefaultPricingStrategy.new(item).call
        item.save!
      end
    else
      new_item = basket.basket_items.build(product:, quantity: 1)
      new_item.tap do |item|
        item.price_cents = DefaultPricingStrategy.new(item).call
        item.save!
      end
    end
  end

  def calculate_basket_item_price(basket_item)
    basket_item.price = DefaultPricingStrategy.new(basket_item).call
    basket_item.save!
  end
end
