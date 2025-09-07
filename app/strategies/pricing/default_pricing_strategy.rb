module Pricing
  class DefaultPricingStrategy < Strategy
    private

    def calculate_pricing
      @basket_item.quantity * @basket_item.product.price
    end
  end
end
