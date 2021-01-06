FactoryBot.define do
  factory :team do
    name { Faker::Sports::Football.team }
    description { Faker::Lorem.sentence(word_count: 3)  }
  end
end
