class ProductOffer < ApplicationRecord
  belongs_to :product
  belongs_to :offer

  validates :product_id, uniqueness: { scope: :offer_id }
end
