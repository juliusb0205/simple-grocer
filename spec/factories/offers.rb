FactoryBot.define do
  factory :offer do
    name { "Sample Offer" }
    description { "A great promotional offer" }
    offer_type { :buy_one_take_one }

    trait :buy_one_take_one do
      offer_type { :buy_one_take_one }
    end

    trait :quantity_discount do
      offer_type { :quantity_discount }

      after(:build) do |offer|
        offer.offer_conditions.build(condition_type: 'minimum_quantity', condition_value: '3')
      end
    end
  end
end
