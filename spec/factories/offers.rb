FactoryBot.define do
  factory :offer do
    name { "Sample Offer" }
    description { "A great promotional offer" }
    discount_type { :quantity_discount }
    rate_type { :percentage_rate }
    percentage_rate { 10.0 }
    minimum_quantity { 2 }

    trait :buy_one_take_one do
      discount_type { :buy_one_take_one }
      rate_type { nil }
      percentage_rate { nil }
      fixed_price_cents { nil }
      minimum_quantity { 2 }
    end

    trait :fixed_price_discount do
      rate_type { :fixed_price }
      percentage_rate { nil }
      fixed_price_cents { 199 }
    end
  end
end
