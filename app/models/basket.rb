class Basket < ApplicationRecord
  has_many :basket_items, dependent: :destroy
  has_many :products, through: :basket_items

  def total_price
    basket_items.sum(&:final_price)
  end
end
