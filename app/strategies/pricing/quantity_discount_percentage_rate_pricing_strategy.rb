module Pricing
  class QuantityDiscountPercentageRatePricingStrategy < Strategy
    def conditions_met?
      minimum_qty = @offer.evaluate_condition("minimum_quantity")&.to_i
      return false unless minimum_qty

      @basket_item.quantity >= minimum_qty
    end

    private

    def calculate_pricing
      @basket_item.quantity * discounted_price
    end

    def discounted_price
      percentage_rate = @offer.evaluate_condition("percentage_rate")&.to_f
      return @basket_item.product.price unless percentage_rate

      original_price_cents = @basket_item.product.price.cents
      discounted_cents = (original_price_cents * (percentage_rate / 100.0)).round
      Money.new(discounted_cents)
    end
  end
end
