FactoryBot.define do
  factory :injection do
    association :patient
    dose { 2.5 }
    lot_number { Faker::Alphanumeric.alphanumeric(number: 6).upcase }
    drug_name { 'Factor VIII' }
    injected_at { Date.current }
  end
end
