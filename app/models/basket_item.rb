class BasketItem < ApplicationRecord
  belongs_to :basket
  belongs_to :product
  belongs_to :applied_offer, class_name: "Offer", optional: true

  monetize :price_cents
  monetize :discount_amount_cents

  validates :quantity, numericality: { only_integer: true, greater_than: 0 }
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :discount_amount, numericality: { greater_than_or_equal_to: 0 }

  def final_price
    price - discount_amount
  end
end
