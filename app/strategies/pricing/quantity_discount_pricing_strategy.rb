module Pricing
  class QuantityDiscountPricingStrategy < Strategy
    def conditions_met?
      @basket_item.quantity >= @offer.minimum_quantity
    end

    private

    def calculate_pricing
      @basket_item.quantity * item_price
    end

    def item_price
      if @offer.fixed_price?
        @offer.fixed_price
      elsif @offer.percentage_rate?
        @basket_item.product.price * (@offer.percentage_rate / 100.0)
      else
        @basket_item.product.price
      end
    end
  end
end
