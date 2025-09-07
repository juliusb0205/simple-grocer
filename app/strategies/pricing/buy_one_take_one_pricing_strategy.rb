module Pricing
  class BuyOneTakeOnePricingStrategy < Strategy

    def conditions_met?
      @basket_item.quantity >= 2
    end

    private

    def calculate_pricing
      paid_quantity = (@basket_item.quantity + 1) / 2
      paid_quantity * @basket_item.product.price
    end
  end
end
