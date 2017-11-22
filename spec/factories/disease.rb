FactoryGirl.define do
  factory :disease do
    name { Faker::Lorem.word }
    facts { [Faker::Lorem.sentence] }
    symptoms { Faker::Lorem.paragraph }
    transmission { Faker::Lorem.paragraph }
    diagnosis { Faker::Lorem.paragraph }
    treatment { Faker::Lorem.paragraph }
    prevention { Faker::Lorem.paragraph }
    more { Faker::Lorem.paragraph }
  end
end