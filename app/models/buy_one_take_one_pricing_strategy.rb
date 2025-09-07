class BuyOneTakeOnePricingStrategy < PricingStrategy
  private

  def calculate_pricing
    paid_quantity = (@basket_item.quantity + 1) / 2
    paid_quantity * @basket_item.product.price
  end
end
