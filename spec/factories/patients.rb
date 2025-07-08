FactoryBot.define do
  factory :patient do
    treatment_schedule_days { 3 }

    trait :with_injections do
      after(:create) do |patient|
        create_list(:injection, 3, patient: patient)
      end
    end
  end
end
