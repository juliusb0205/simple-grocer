module Pricing
  class StrategyResolver
    STRATEGY_MAP = {
      "buy_one_take_one" => Pricing::BuyOneTakeOnePricingStrategy,
      "quantity_discount" => Pricing::QuantityDiscountPricingStrategy
    }.freeze

    def self.create(basket_item, offer = nil)
      if offer.nil? || !self.offer_applies_to_product?(basket_item.product, offer)
        return DefaultPricingStrategy.new(basket_item, offer)
      end

      strategy = STRATEGY_MAP[offer.offer_type]&.new(basket_item, offer)

      return strategy if strategy&.conditions_met?

      DefaultPricingStrategy.new(basket_item, offer)
    end

    private

    def self.offer_applies_to_product?(product, offer)
      ProductOffer.exists?(product:, offer:)
    end
  end
end
