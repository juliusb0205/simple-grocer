module Pricing
  class BuyXTakeYPricingStrategy < Strategy
    def conditions_met?
      @basket_item.quantity >= base_quantity
    end

    private

    def calculate_pricing
      complete_sets = @basket_item.quantity / total_quantity_per_set
      remaining_items = @basket_item.quantity % total_quantity_per_set

      paid_quantity = complete_sets * base_quantity

      if remaining_items >= base_quantity
        paid_quantity += base_quantity
      else
        paid_quantity += remaining_items
      end

      paid_quantity * @basket_item.product.price
    end

    def base_quantity
      @offer.evaluate_condition("base_quantity")&.to_i || 1
    end

    def free_quantity
      @offer.evaluate_condition("free_quantity")&.to_i || 1
    end

    def total_quantity_per_set
      base_quantity + free_quantity
    end

    def minimum_quantity_for_promo
      base_quantity
    end
  end
end
