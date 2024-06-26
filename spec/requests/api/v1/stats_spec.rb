require 'swagger_helper'

RSpec.describe 'Stats API', type: :request do
  before do
    Sidekiq::Testing.fake!
  end

  path '/api/v1/games/{game_id}/stats' do
    parameter name: :game_id, in: :path, type: :string, description: 'Game ID'

    get("List a game's stats") do
      tags 'Stats'
      produces 'application/json'

      response(200, 'successful') do
        let(:game_id) { create(:game, number_of_questions: 2).id }
        before { create(:player, answers_correct: 0, game_id: game_id) }
        before { create(:player, answers_correct: 1, game_id: game_id) }

        schema({
          type: :object,
          properties: {
            data: {
              type: :object,
              properties: {
                id: { type: :integer },
                type: { type: :string },
                attributes: {
                  type: :object,
                  properties: {
                    game_id: { type: :number},
                    avg_correct_answers: { type: :number, format: :float, required: true }
                  }
                },
                relationships: {
                  type: :object,
                  properties: {
                    games: {
                      type: :object,
                      properties: {
                        data: {
                          type: :array,
                          items: {
                            type: :object,
                            properties: {
                              id: { type: :integer},
                              type: { type: :string },
                              attributes: {
                                type: :object,
                                properties: {
                                  link: { type: :string },
                                  started: { type: :boolean },
                                  number_of_questions: { type: :integer },
                                  number_of_players: { type: :integer },
                                  topic: { type: :string },
                                  time_limit: { type: :integer }
                                }
                              }
                            }
                          }
                        }
                      }
                    },
                    players: {
                      type: :object,
                      properties: {
                        data: {
                          type: :array,
                          items: {
                            type: :object,
                            properties: {
                              id: { type: :integer},
                              type: { type: :string },
                              attributes: {
                                type: :object,
                                properties: {
                                  display_name: { type: :string },
                                  answers_correct: { type: :integer },
                                  answers_incorrect: { type: :integer },
                                  questions_correct: { 
                                    type: :array,
                                    items: { type: :string }
                                  }
                                }
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        })

        run_test! do |example|
          expect(response).to have_http_status(200)

          parsed_data = JSON.parse(response.body, symbolize_names: true)[:data]
          expect(parsed_data[:id].to_i).to eq Stat.last.id
          expect(parsed_data[:type]).to eq "stat"

          attributes = parsed_data[:attributes]
          expect(attributes[:game_id]).to eq game_id
          expect(attributes[:avg_correct_answers]).to eq 50.0

          games = parsed_data[:relationships][:games][:data]
          expect(games.size).to eq 1
          expect(games.first[:id]).to eq game_id
          expect(games.first[:type]).to eq "game"

          players = parsed_data[:relationships][:players][:data]
          expect(players.size).to eq 2
          expect(players).to all(include(type: "player"))
        end
      end

      response(404, 'Game ID not found') do
        let(:game_id) { -1 }

        run_test! do |example|
          expect(response.status).to eq 404

          error = JSON.parse(response.body, symbolize_names: true)[:error]
          expect(error[:message]).to eq "Couldn't find Game with 'id'=-1"
        end
      end
    end
  end

  path '/api/v1/games/{game_id}/stats/email' do
    parameter name: :game_id, in: :path, type: :string, description: 'Game ID'
    
    
    post("Send game's stats via Email") do
      tags 'Stats'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :params, in: :body, required: true, schema: {
          type: :object,
          properties: {
            email: { type: :string, required: true, description: 'Player Email' },
          }
        }

      response(200, 'successful') do
        let(:game) { create(:game, number_of_questions: 2) }
        let(:game_id) { game.id }
        let(:email) { 'example@mail.com' }
        let(:params) { {email: email} }
        before { 2.times { create(:player, answers_correct: 1, game_id: game_id) } }

        schema({
          type: :object,
          properties: {
            message: { type: :string }
          }
        })

        run_test! do |example|
          expect(response).to have_http_status(200)

          parsed_data = JSON.parse(response.body, symbolize_names: true)
          expect(parsed_data[:message]).to eq "Stats sent successfully"

          expect {
            post "/api/v1/games/#{game_id}/stats/email", params: { email: email }
          }.to change { Sidekiq::Queues['default'].size }.by(1)
        end
      end

      response(404, "Stat's game not found") do
        let(:game_id) { -1 }
        let(:email) { 'example@mail.com' }
        let(:params) { {email: email} }

        run_test! do |example|
          expect(response).to have_http_status(404)

          error = JSON.parse(response.body, symbolize_names: true)[:error]
          expect(error[:message]).to eq "Couldn't find Game with 'id'=-1"
        end
      end
    end
  end
end
