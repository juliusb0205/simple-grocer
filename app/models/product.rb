class Product < ApplicationRecord
  monetize :price_cents

  has_many :product_offers, dependent: :destroy
  has_many :offers, through: :product_offers

  validates :product_code, length: { is: 3, message: "must be exactly 3 characters" }
end
