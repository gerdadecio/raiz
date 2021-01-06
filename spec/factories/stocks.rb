FactoryBot.define do
  factory :stock do
    name { Faker::Company.name }
    code { Faker::Company.sic_code }
    company { Faker::Company.industry }
  end
end
