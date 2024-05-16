class StatSerializer
  # include JSONAPI::Serializer
  # attributes :avg_correct_answers
  # include JSONAPI::Serializer
  # attributes :link, :started, :number_of_questions, :number_of_players, :topic, :time_limit

  # has_many :players
  # has_many :questions

  def self.format(stat)
    {
      data: {
        id: stat.id,
        type: "stat",
        attributes: {
          game_id: stat.game.id,
          avg_correct_answers: stat.avg_correct_answers
        },
        relationships: {
          games: {
            data: [
              {
                id: stat.game.id,
                type: "game",
                attributes: {
                  link: stat.game.link,
                  started: stat.game.started,
                  number_of_questions: stat.game.number_of_questions,
                  number_of_players: stat.game.number_of_players,
                  topic: stat.game.topic,
                  time_limit: stat.game.time_limit
                }
              }
            ]
          },
          players: {
            data: stat.game.players.map do |player|
              {
                id: player.id,
                type: "player",
                attributes: {
                  display_name: player.display_name,
                  answers_correct: player.answers_correct,
                  answers_incorrect: player.answers_incorrect
                }
              }
            end
          }
        }
      }
    }
  end
end