class ProductScanner
  attr_reader :basket

  def initialize(basket)
    @basket = basket
  end

  def scan(product_code)
    product = Product.find_by(product_code:)
    return false unless product

    existing_item = basket.basket_items.find_by(product:)

    if existing_item
      existing_item.increment!(:quantity)
    else
      basket.basket_items.create!(product:, quantity: 1)
    end

    true
  end
end
