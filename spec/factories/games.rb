FactoryBot.define do
  factory :game do
    topic { "MyString" }
    number_of_questions { 1 }
    time_limit { 1 }
    number_of_players { 1 }
    started { false }
    link { "MyString" }
  end
end
