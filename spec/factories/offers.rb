FactoryBot.define do
  factory :offer do
    name { "Sample Offer" }
    description { "A great promotional offer" }
    offer_type { :quantity_discount }

    trait :buy_one_take_one do
      offer_type { :buy_one_take_one }
    end
  end
end
