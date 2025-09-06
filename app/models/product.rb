class Product < ApplicationRecord
  monetize :price_cents

  validates :product_code, length: { is: 3, message: "must be exactly 3 characters" }
end
