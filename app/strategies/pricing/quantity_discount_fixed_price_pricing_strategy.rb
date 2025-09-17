module Pricing
  class QuantityDiscountFixedPricePricingStrategy < Strategy
    def conditions_met?
      minimum_qty = @offer.evaluate_condition("minimum_quantity")&.to_i
      return false unless minimum_qty

      @basket_item.quantity >= minimum_qty
    end

    private

    def calculate_pricing
      @basket_item.quantity * fixed_price_in_cents
    end

    def fixed_price_in_cents
      fixed_price = @offer.evaluate_condition("fixed_price")&.to_f
      return @basket_item.product.price unless fixed_price

      Money.new((fixed_price * 100).round)
    end
  end
end
