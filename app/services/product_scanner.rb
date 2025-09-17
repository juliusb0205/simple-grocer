class ProductScanner
  attr_reader :basket

  def initialize(basket)
    @basket = basket
  end

  def scan(product_code)
    product = Product.find_by(product_code:)
    return false unless product

    basket_item = add_product_to_basket(product)

    # Apply basket-wide promotions after each scan
    BasketPromotionService.new(basket).apply_promotions!

    true
  end

  private

  def add_product_to_basket(product)
    existing_item = basket.basket_items.find_by(product:)

    if existing_item
      existing_item.tap do |item|
        item.quantity += 1
        strategy = Pricing::StrategyResolver.create(item, product.offer)
        item.price = strategy.call
        item.applied_offer = strategy.applied_offer
        item.save!
      end
    else
      new_item = basket.basket_items.build(product:, quantity: 1)
      new_item.tap do |item|
        strategy = Pricing::StrategyResolver.create(item, product.offer)
        item.price = strategy.call
        item.applied_offer = strategy.applied_offer
        item.save!
      end
    end
  end
end
