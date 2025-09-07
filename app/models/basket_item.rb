class BasketItem < ApplicationRecord
  belongs_to :basket
  belongs_to :product

  monetize :price_cents

  validates :quantity, numericality: { only_integer: true, greater_than: 0 }
  validates :price, presence: true, numericality: { greater_than: 0 }
end
