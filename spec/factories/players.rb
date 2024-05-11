FactoryBot.define do
  factory :player do
    display_name { "MyString" }
    answers_correct { 1 }
    answers_incorrect { 1 }
    game { nil }
  end
end
