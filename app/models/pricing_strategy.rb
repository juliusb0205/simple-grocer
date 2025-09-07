class PricingStrategy
  def initialize(basket_item, offer = nil)
    @offer = offer
    @basket_item = basket_item
  end

  def call
    calculate_pricing
  end

  private

  def calculate_pricing
    raise NotImplementedError, "Subclasses must implement calculate_pricing method"
  end
end
