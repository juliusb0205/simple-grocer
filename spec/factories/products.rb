FactoryBot.define do
  factory :product do
    sequence(:product_code) { |n| "XX#{n}" }
    name { "Sample Product" }
    price_cents { 1000 }
  end
end
