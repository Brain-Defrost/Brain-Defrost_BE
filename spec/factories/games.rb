FactoryBot.define do
  factory :game do
    topic { Faker::Educator.subject }
    number_of_questions { Faker::Number.within(range: 1..10) }
    time_limit { Faker::Number.within(range: 5..120) }
    number_of_players { Faker::Number.within(range: 1..35) }
    started { false }
    link { Faker::Internet.url }
  end
end
