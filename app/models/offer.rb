class Offer < ApplicationRecord
  has_many :product_offers, dependent: :destroy
  has_many :products, through: :product_offers
  has_many :offer_conditions, dependent: :destroy

  enum :offer_type, {
    buy_x_take_y: 0,
    quantity_discount_fixed_price: 1,
    quantity_discount_percentage_rate: 2,
    basket_buy_x_lowest_free: 3
  }

  validates :name, presence: true, uniqueness: true
  validates :offer_type, presence: true
  validate :required_conditions_present

  DISCOUNT_TYPE_CONFIGS = {
    "buy_x_take_y" => {
      required: [ "base_quantity", "free_quantity" ]
    },
    "quantity_discount_fixed_price" => {
      required: [ "minimum_quantity", "fixed_price" ]
    },
    "quantity_discount_percentage_rate" => {
      required: [ "minimum_quantity", "percentage_rate" ]
    },
    "basket_buy_x_lowest_free" => {
      required: [ "minimum_items" ]
    }
  }.freeze

  def evaluate_condition(condition_type)
    offer_conditions.find_by(condition_type: condition_type.to_s)&.condition_value
  end

  private

  def required_conditions_present
    return unless offer_type

    required_conditions = DISCOUNT_TYPE_CONFIGS[offer_type.to_s]&.dig(:required) || []
    return if required_conditions.empty?

    # For new records, check if any conditions are built but not saved
    # For persisted records, check the actual database state
    conditions = persisted? ? offer_conditions.reload : offer_conditions.to_a
    existing_condition_types = conditions.map(&:condition_type)

    missing_conditions = required_conditions - existing_condition_types

    if missing_conditions.any?
      errors.add(:offer_conditions, "Missing required conditions: #{missing_conditions.join(', ')}")
    end
  end
end
