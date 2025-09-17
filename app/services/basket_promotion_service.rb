class BasketPromotionService
  def initialize(basket)
    @basket = basket
  end

  def apply_promotions!
    basket_offers = Offer.where(offer_type: basket_level_types)

    basket_offers.each do |offer|
      strategy = create_basket_strategy(offer)
      strategy.apply! if strategy.conditions_met?
    end
  end

  private

  def basket_level_types
    [ "basket_buy_x_lowest_free" ]
  end

  def create_basket_strategy(offer)
    case offer.offer_type
    when "basket_buy_x_lowest_free"
      Pricing::BasketBuyXLowestFreePricingStrategy.new(@basket, offer)
    else
      raise "Unknown basket offer type: #{offer.offer_type}"
    end
  end
end
