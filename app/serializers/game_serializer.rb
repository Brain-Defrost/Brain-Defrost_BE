class GameSerializer
  # include JSONAPI::Serializer
  # attributes :link, :started, :number_of_questions, :number_of_players, :topic, :time_limit

  # has_many :players
  # has_many :questions

  def initialize(game, questions = [])
    {
      data: {
        id: game.id,
        type: "game",
        attributes: {
          link: game.link, 
          started: game.started, 
          number_of_questions: game.number_of_questions, 
          number_of_players: game.number_of_players, 
          topic: game.topic, 
          time_limit: game.time_limit
        },
        relationships: {
          players: {
            data: game.players.map do |player|
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
          },
          questions: {
            data: questions.map do |question|
              {
                id: nil,
                type: "question",
                attributes: {
                  topic: question.topic, 
                  question_text: question.question_text,
                  question_number: question.question_number,
                  answer: question.answer,
                  options: question.options
                }
              }
            end
          }
        }
      }
    }
  end
end