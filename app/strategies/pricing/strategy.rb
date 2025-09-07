module Pricing
  class Strategy
    def initialize(basket_item, offer = nil)
      @offer = offer
      @basket_item = basket_item
    end

    def call
      calculate_pricing
    end

    def conditions_met?
      raise NotImplementedError, "Subclasses must implement conditions_met? method"
    end

    private

    def calculate_pricing
      raise NotImplementedError, "Subclasses must implement calculate_pricing method"
    end
  end
end
