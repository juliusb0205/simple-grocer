FactoryBot.define do
  factory :offer_condition do
    offer { nil }
    condition_type { "MyString" }
    condition_value { "MyText" }
  end
end
