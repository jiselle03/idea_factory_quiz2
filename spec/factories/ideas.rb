FactoryBot.define do
  factory :idea do
    title { Faker::Movies::StarWars.character }
    description { Faker::Movies::StarWars.quote }
  end
end
