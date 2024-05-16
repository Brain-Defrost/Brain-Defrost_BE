require 'swagger_helper'

RSpec.describe 'Players API', type: :request do

  path '/api/v1/games/{game_id}/players' do
    parameter name: :game_id, in: :path, type: :string, description: 'Game ID'

    get("List a game's players") do
      tags 'Player'
      produces 'application/json'

      response(200, 'successful') do
        let(:game_id) { create(:game).id }
        before { 2.times do create(:player, game_id: game_id) end}

        schema({
          type: :object,
          properties: {
            data: {
              type: :array,
              items: {
                type: :object,
                properties: {
                  id: { type: :string, required: true },
                  type: { type: :string, required: true },
                  attributes: {
                    type: :object,
                    properties: {
                      display_name: { type: :string, required: true },
                      answers_correct: { type: :integer, required: true },
                      answers_incorrect: { type: :integer, required: true },
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
        })

        run_test! do |example|
          expect(response).to have_http_status(200)

          parsed_data = JSON.parse(response.body, symbolize_names: true)
          expect(parsed_data[:data].size).to eq 2
          expect(parsed_data[:data]).to all(include(type: "player"))
        end
      end

      response(404, "Player's game not found") do
        let(:game_id) { -1 }
        let(:params) { {display_name: 'I know all the facts'} }

        run_test! do |example|
          expect(response.status).to eq 404

          error = JSON.parse(response.body, symbolize_names: true)[:error]
          expect(error[:message]).to eq "Couldn't find Game with 'id'=-1"
        end
      end
    end

    post('Add new player to game') do
      tags 'Player'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: { display_name: { type: :string, required: true } }
      }

      response(201, 'successfully created') do
        let(:game_id) { create(:game).id }
        let(:params) { { display_name: 'trivia-ninja'} }

        schema({
          type: :object,
          properties: {
            data: {
              type: :object,
              properties: {
                id: { type: :string, required: true },
                type: { type: :string, required: true },
                attributes: {
                  type: :object,
                  properties: {
                    display_name: { type: :string, required: true },
                    answers_correct: { type: :integer, required: true },
                    answers_incorrect: { type: :integer, required: true },
                    questions_correct: { 
                      type: :array,
                      items: { type: :string }
                    }
                  }
                }
              }
            }
          }
        })

        run_test! do |example|
          expect(response.status).to eq 201

          parsed_data = JSON.parse(response.body, symbolize_names: true)[:data]
          expect(parsed_data[:id].to_i).to eq Player.last.id
          expect(parsed_data[:type]).to eq "player"
          expect(parsed_data[:attributes][:display_name]).to eq params[:display_name]
          expect(parsed_data[:attributes][:answers_correct]).to eq 0
          expect(parsed_data[:attributes][:answers_incorrect]).to eq 0
          expect(parsed_data[:attributes][:questions_correct]).to eq []
        end
      end

      response(400, 'Invalid or missing data') do
        let(:game_id) { create(:game).id }
        let(:params) { {display_name: 'if you came from Games API then you know this is yet another really long display name'} }

        run_test! do |example|
          expect(response.status).to eq 400

          error = JSON.parse(response.body, symbolize_names: true)[:error]
          expect(error[:message]).to eq "Validation failed: Display name is too long (maximum is 30 characters)"
        end
      end

      response(400, 'Invalid or missing data') do
        let(:game_id) { create(:game).id }
        let(:params) { {display_name: ''} }

        run_test! do |example|
          expect(response.status).to eq 400

          error = JSON.parse(response.body, symbolize_names: true)[:error]
          expect(error[:message]).to eq "Validation failed: Display name can't be blank, Display name is too short (minimum is 1 character)"
        end
      end

      response(404, "Player's game not found") do
        let(:game_id) { -1 }
        let(:params) { {display_name: 'I know all the facts'} }

        run_test! do |example|
          expect(response.status).to eq 404

          error = JSON.parse(response.body, symbolize_names: true)[:error]
          expect(error[:message]).to eq "Couldn't find Game with 'id'=-1"
        end
      end

      response(422, 'Display name taken') do
        let(:game_id) { create(:game).id }
        before { create(:player, display_name: 'trivia-ninja', game_id: game_id) }
        let(:params) { {display_name: 'trivia-ninja'} }

        run_test! do |example|
          expect(response.status).to eq 422

          error = JSON.parse(response.body, symbolize_names: true)[:error]
          expect(error[:message]).to eq "Validation failed: Display name has already been taken"
        end
      end

      response(403, 'Game has started') do
        let(:game_id) { create(:game, started: true).id }
        let(:params) { {display_name: 'here'} }

        run_test! do |example|
          expect(response.status).to eq 403

          error = JSON.parse(response.body, symbolize_names: true)[:error]
          expect(error[:message]).to eq "Game started. New players may not join."
        end
      end

      response(403, 'New players may not join game') do
        let(:game_id) { create(:game, number_of_players: 1).id }
        before { create(:player, display_name: 'player 1', game_id: game_id) }
        let(:params) { {display_name: 'player 2'} }

        run_test! do |example|
          expect(response.status).to eq 403

          error = JSON.parse(response.body, symbolize_names: true)[:error]
          expect(error[:message]).to eq "Max players reached. New players may not join." 
        end
      end
    end
  end

  path '/api/v1/games/{game_id}/players/{id}' do
    parameter name: :game_id, in: :path, type: :string, description: 'Game ID'
    parameter name: :id, in: :path, type: :string, description: 'Player ID'

    get('Find player by ID') do
      tags 'Player'
      produces 'application/json'

      response(200, 'successful') do
        let(:game_id) { create(:game).id }
        let(:id) { create(:player, game_id: game_id).id }

        schema({
          type: :object,
          properties: {
            data: {
              type: :object,
              properties: {
                id: { type: :string, required: true },
                type: { type: :string, required: true },
                attributes: {
                  type: :object,
                  properties: {
                    display_name: { type: :string, required: true },
                    answers_correct: { type: :integer, required: true },
                    answers_incorrect: { type: :integer, required: true },
                    questions_correct: { 
                      type: :array,
                      items: { type: :string }
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
          expect(parsed_data[:id].to_i).to eq id
          expect(parsed_data[:type]).to eq "player"
        end
      end

      response(404, 'invalid game id') do
        let(:game_id) { -1 }
        let(:id) { create(:player).id }

        run_test! do |example|
          expect(response.status).to eq 404

          error = JSON.parse(response.body, symbolize_names: true)[:error]
          expect(error[:message]).to eq "Couldn't find Player with 'id'=#{id} and 'game_id'=-1"
        end
      end

      response(404, 'Player or game ID not found') do
        let(:game_id) { create(:game).id }
        let(:id) { -1 }

        run_test! do |example|
          expect(response.status).to eq 404

          error = JSON.parse(response.body, symbolize_names: true)[:error]
          expect(error[:message]).to eq "Couldn't find Player with 'id'=-1 and 'game_id'=#{game_id}"
        end
      end
    end

    patch('Update an existing player') do
      tags 'Player'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: { 
          question: { type: :integer },
          correct: { type: :boolean }
        }
      }

      response(200, 'successful') do
        let(:game_id) { create(:game).id }
        let(:id) { create(:player, answers_correct: 0, game_id: game_id).id }
        let(:params) { { question: 1, correct: true } }

        schema({
          type: :object,
          properties: {
            data: {
              type: :object,
              properties: {
                id: { type: :string, required: true },
                type: { type: :string, required: true },
                attributes: {
                  type: :object,
                  properties: {
                    display_name: { type: :string, required: true },
                    answers_correct: { type: :integer, required: true },
                    answers_incorrect: { type: :integer, required: true },
                    questions_correct: { 
                      type: :array,
                      items: { type: :string }
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
          expect(parsed_data[:id].to_i).to eq id
          expect(parsed_data[:type]).to eq "player"
          expect(parsed_data[:attributes][:answers_correct]).to eq 1
          expect(parsed_data[:attributes][:questions_correct]).to eq ["1"]
        end
      end

      response(404, "Invalid game ID") do
        let(:game_id) { -1 }
        let(:id) { create(:player).id }
        let(:params) { { question: 1, correct: true } }

        run_test! do |example|
          expect(response.status).to eq 404

          error = JSON.parse(response.body, symbolize_names: true)[:error]
          expect(error[:message]).to eq "Couldn't find Player with 'id'=#{id} and 'game_id'=-1"
        end
      end

      response(404, 'Player or game ID not found') do
        let(:game_id) { create(:game).id }
        let(:id) { -1 }
        let(:params) { { question: 1, correct: true } }

        run_test! do |example|
          expect(response.status).to eq 404

          error = JSON.parse(response.body, symbolize_names: true)[:error]
          expect(error[:message]).to eq "Couldn't find Player with 'id'=-1 and 'game_id'=#{game_id}"
        end
      end
    end

    delete('Delete an existing player') do
      tags 'Player'
      produces 'application/json'

      response(204, 'successful') do
        let(:game_id) { create(:game).id }
        let(:id) { create(:player, game_id: game_id).id }

        run_test! do |example|
          expect(response).to have_http_status(204)
        end
      end

      response(404, 'invalid game id') do
        let(:game_id) { -1 }
        let(:id) { create(:player).id }
  
        run_test! do |example|
          expect(response.status).to eq 404

          error = JSON.parse(response.body, symbolize_names: true)[:error]
          expect(error[:message]).to eq "Couldn't find Player with 'id'=#{id} and 'game_id'=-1"
        end
      end
  
      response(404, 'Player or game ID not found') do
        let(:game_id) { create(:game).id }
        let(:id) { -1 }
  
        run_test! do |example|
          expect(response.status).to eq 404

          error = JSON.parse(response.body, symbolize_names: true)[:error]
          expect(error[:message]).to eq "Couldn't find Player with 'id'=-1 and 'game_id'=#{game_id}"
        end
      end
    end
  end
end