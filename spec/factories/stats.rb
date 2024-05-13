FactoryBot.define do
  factory :stat do
    avg_correct_answers { Faker::Number.within(range: 0.0..10.0) }
    game { create(:game) }
  end
end
