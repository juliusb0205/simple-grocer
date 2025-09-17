module Pricing
  class BasketBuyXLowestFreePricingStrategy
    def initialize(basket, offer)
      @basket = basket
      @offer = offer
    end

    def conditions_met?
      total_items >= minimum_items
    end

    def apply!
      clear_previous_discounts
      apply_new_discounts
    end

    private

    def minimum_items
      @offer.evaluate_condition("minimum_items")&.to_i || 3
    end

    def total_items
      eligible_basket_items.sum(:quantity)
    end

    def clear_previous_discounts
      @basket.basket_items.where(applied_offer: @offer).update_all(
        discount_amount_cents: 0,
        applied_offer_id: nil
      )
    end

    def apply_new_discounts
      free_items_count = total_items / minimum_items
      return if free_items_count == 0

      # Create list of individual items with their unit prices (only eligible products)
      individual_items = []
      eligible_basket_items.each do |basket_item|
        unit_price = basket_item.product.price
        basket_item.quantity.times do
          individual_items << { basket_item:, unit_price: }
        end
      end

      # Sort by unit price (cheapest first)
      individual_items.sort_by! { |item| item[:unit_price] }

      # Apply discounts to cheapest items
      discount_tracker = Hash.new(0)

      free_items_count.times do |i|
        cheapest_item = individual_items[i]
        basket_item = cheapest_item[:basket_item]
        unit_price = cheapest_item[:unit_price]

        discount_tracker[basket_item] += unit_price
      end

      # Update basket items with accumulated discounts
      discount_tracker.each do |basket_item, total_discount|
        basket_item.update!(
          discount_amount: Money.new(total_discount.cents),
          applied_offer: @offer
        )
      end
    end

    def eligible_basket_items
      eligible_product_ids = @offer.products.pluck(:id)
      @basket.basket_items.joins(:product).where(product: { id: eligible_product_ids })
    end
  end
end
