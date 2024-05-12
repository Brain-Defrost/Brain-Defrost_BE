FactoryBot.define do
  factory :player do
    display_name { Faker::Internet.unique.username }
    answers_correct { Faker::Number.within(range: 1..5) }
    answers_incorrect { Faker::Number.within(range: 1..5) }
    game { create(:game) }
  end
end
