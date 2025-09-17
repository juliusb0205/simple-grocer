class Offer < ApplicationRecord
  has_many :product_offers, dependent: :destroy
  has_many :products, through: :product_offers
  has_many :offer_conditions, dependent: :destroy

  enum :offer_type, {
    buy_one_take_one: 0,
    quantity_discount: 1
  }

  validates :name, presence: true, uniqueness: true
  validates :offer_type, presence: true
end
