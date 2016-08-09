FactoryGirl.define do
  factory :disease do
    name { Faker::Lorem.word }
  end
end