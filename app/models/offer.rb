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
  validate :required_conditions_present

  DISCOUNT_TYPE_CONFIGS = {
    "buy_one_take_one" => {
      required: []
    },
    "quantity_discount" => {
      required: [ "minimum_quantity" ]
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
