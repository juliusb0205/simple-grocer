class Offer < ApplicationRecord
  monetize :fixed_price_cents, allow_nil: true

  has_many :product_offers, dependent: :destroy
  has_many :products, through: :product_offers

  enum :discount_type, {
    buy_one_take_one: 0,
    quantity_discount: 1
  }

  enum :rate_type, {
    fixed_price: 0,
    percentage_rate: 1
  }

  validates :name, presence: true, uniqueness: true
  validates :discount_type, presence: true
  validates :rate_type, presence: true, if: :quantity_discount?
  validates :fixed_price_cents, presence: true, numericality: { greater_than: 0 }, if: :requires_fixed_price?
  validates :percentage_rate, presence: true, if: :requires_percentage_rate?
  validates :percentage_rate,
    numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 },
    allow_nil: true
  validates :minimum_quantity,
    presence: true,
    numericality: { only_integer: true, greater_than: 1 },
    if: -> { quantity_discount? }

  private

  def requires_fixed_price?
    quantity_discount? && fixed_price?
  end

  def requires_percentage_rate?
    quantity_discount? && percentage_rate?
  end
end
