class Product < ApplicationRecord
  monetize :price_cents

  # NOTE: Changed to `has_one` to reflect the one-to-one relationship
  # Change to `has_many` if a product can have multiple offers in the future
  has_one :product_offer, dependent: :destroy
  has_one :offer, through: :product_offer

  validates :product_code, length: { is: 3, message: "must be exactly 3 characters" }
end
