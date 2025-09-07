class Basket < ApplicationRecord
  has_many :basket_items, dependent: :destroy
  has_many :products, through: :basket_items

  def total_price
    Money.new(basket_items.sum(:price_cents))
  end
end
