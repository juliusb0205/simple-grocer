require 'securerandom'

FactoryBot.define do
  factory :product do
    product_code { SecureRandom.alphanumeric(3).upcase }
    name { "Sample Product" }
    price_cents { 1000 }
  end
end
