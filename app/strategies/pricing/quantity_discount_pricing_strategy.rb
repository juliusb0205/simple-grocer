module Pricing
  class QuantityDiscountPricingStrategy < Strategy
    def conditions_met?
      minimum_qty = @offer.evaluate_condition(:minimum_quantity)&.to_i
      return false unless minimum_qty

      @basket_item.quantity >= minimum_qty
    end

    private

    def calculate_pricing
      @basket_item.quantity * item_price
    end

    def item_price
      fixed_price = @offer.evaluate_condition(:fixed_price)&.to_f
      percentage_rate = @offer.evaluate_condition(:percentage_rate)&.to_f

      if fixed_price
        fixed_price
      elsif percentage_rate
        @basket_item.product.price * (percentage_rate / 100.0)
      else
        @basket_item.product.price
      end
    end
  end
end
