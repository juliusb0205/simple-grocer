class BasketsController < ApplicationController
  def index
    @baskets = Basket.includes(basket_items: :product).all
  end
end
