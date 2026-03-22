FactoryBot.define do
  factory :disease do
    name { Faker::Lorem.word }
    facts { [Faker::Lorem.sentence] }
    symptoms { [Faker::Lorem.sentence, Faker::Lorem.sentence] }
    transmission { [Faker::Lorem.sentence, Faker::Lorem.sentence] }
    diagnosis { [Faker::Lorem.sentence, Faker::Lorem.sentence] }
    treatment { [Faker::Lorem.sentence, Faker::Lorem.sentence] }
    prevention { [Faker::Lorem.sentence, Faker::Lorem.sentence] }
    more { Faker::Lorem.paragraph }
  end
end