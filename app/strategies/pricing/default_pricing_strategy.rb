module Pricing
  class DefaultPricingStrategy < Strategy
    def applied_offer
      nil # No offer applied when using default pricing
    end

    private

    def calculate_pricing
      @basket_item.quantity * @basket_item.product.price
    end
  end
end
