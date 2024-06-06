require 'swagger_helper'

RSpec.describe 'Stats API', type: :request do

  path '/api/v1/games/{game_id}/stats' do
    parameter name: :game_id, in: :path, type: :string, description: 'Game ID'

    get("List a game's stats") do
      tags 'Stats'
      produces 'application/json'

      response(200, 'successful') do
        let(:game_id) { create(:game, number_of_questions: 2).id }
        let(:id) { create(:player, answers_correct: 2, game_id: game_id) }
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
                                  answers_incorrect: { type: :integer }
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

          expect(parsed_data).to be_a(Hash)
          expect(parsed_data[:id]).to be_a(Integer)
          expect(parsed_data[:type]).to be_a(String)

          attributes = parsed_data[:attributes]

          expect(attributes[:game_id]).to be_a(Integer)
          expect(attributes[:avg_correct_answers]).to be_a(Float)
          expect(attributes[:avg_correct_answers]).to eq 50.0

          relationships = parsed_data[:relationships]

          expect(relationships).to be_a(Hash)

          expect( relationships[:games][:data]).to be_a(Array)
          expect( relationships[:games][:data].first[:id]).to be_a(Integer)
          expect( relationships[:games][:data].first[:type]).to be_a(String)
          expect( relationships[:games][:data].first[:attributes]).to be_a(Hash)
          expect( relationships[:games][:data].first[:attributes][:link]).to be_a(String)
          expect( relationships[:games][:data].first[:attributes][:number_of_questions]).to be_a(Integer)
          expect( relationships[:games][:data].first[:attributes][:number_of_players]).to be_a(Integer)
          expect( relationships[:games][:data].first[:attributes][:topic]).to be_a(String)
          expect( relationships[:games][:data].first[:attributes][:time_limit]).to be_a(Integer)
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

  path '/api/v1/games/{game_id}/stats/{email}' do
    parameter name: :game_id, in: :path, type: :string, description: 'Game ID'
    parameter name: :email, in: :path, type: :string, description: 'Player Email'

    post("Send game's stats via Email") do
      tags 'Stats'
      produces 'application/json'

      response(200, 'successful') do
        let(:game_id) { create(:game, number_of_questions: 2).id }
        let(:email) { 'example@mail.com' }
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
          expect(parsed_data).to be_a(Hash)
          expect(parsed_data[:message]).to eq "Stats sent successfully"

          expect {
            post '/api/v1/games/1/stats/example@mail.com'
          }.to change { Sidekiq::Queue.new('mailers').size }.by(1)
        end
      end

      response(404, 'invalid game id') do
        let(:game_id) { -1 }
        let(:email) { 'example@mail.com' }
        let (:game_1) { create(:game, number_of_questions: 2) }
        before { create(:player, game_id: game_1.id) }

        run_test! do |example|
          expect(response.status).to eq 404

          error = JSON.parse(response.body, symbolize_names: true)[:error]
          expect(error[:message]).to eq "Couldn't find Game with 'id'=-1"
        end
      end
    end
  end
end
