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
    data_source { 'WHO' }
    prevalence { nil }

    trait :orphanet do
      data_source { 'ORPHANET' }
      prevalence { 5.0 }
    end
  end
end