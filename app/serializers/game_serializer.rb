class GameSerializer
  include JSONAPI::Serializer
  attributes :link, :started, :number_of_questions, :number_of_players, :topic, :time_limit
end