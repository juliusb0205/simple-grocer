FactoryBot.define do
  factory :offer_condition do
    association :offer
    condition_type { "minimum_quantity" }
    condition_value { "3" }
  end
end
