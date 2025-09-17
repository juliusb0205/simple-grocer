FactoryBot.define do
  factory :offer do
    name { "Sample Offer" }
    description { "A great promotional offer" }
    offer_type { :buy_x_take_y }

    after(:build) do |offer|
      if offer.offer_type == 'buy_x_take_y'
        offer.offer_conditions.build(condition_type: 'base_quantity', condition_value: '1')
        offer.offer_conditions.build(condition_type: 'free_quantity', condition_value: '1')
      end
    end

    trait :buy_x_take_y do
      offer_type { :buy_x_take_y }

      transient do
        base_quantity { 1 }
        free_quantity { 1 }
      end

      after(:build) do |offer, evaluator|
        offer.offer_conditions.clear
        offer.offer_conditions.build(condition_type: 'base_quantity', condition_value: evaluator.base_quantity.to_s)
        offer.offer_conditions.build(condition_type: 'free_quantity', condition_value: evaluator.free_quantity.to_s)
      end
    end

    trait :quantity_discount do
      offer_type { :quantity_discount }

      after(:build) do |offer|
        offer.offer_conditions.clear
        offer.offer_conditions.build(condition_type: 'minimum_quantity', condition_value: '3')
      end
    end
  end
end
