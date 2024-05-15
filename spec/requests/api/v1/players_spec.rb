require 'swagger_helper'

RSpec.describe 'Players API', type: :request do

  path '/api/v1/games/{game_id}/players' do
    
    post('Add new player to game') do
      tags 'Player'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :game_id, in: :path, type: :string, description: 'Game ID'

      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: { type: :string, required: true }
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
                    answers_incorrect: { type: :integer, required: true }
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
          expect(parsed_data[:attributes][:display_name]).to eq "trivia-ninja"
          expect(parsed_data[:attributes][:answers_correct]).to eq 0
          expect(parsed_data[:attributes][:answers_incorrect]).to eq 0
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

      response(404, 'Invalid or missing data') do
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
    end
  end

  # path '/api/v1/games/{game_id}/players/{id}' do
  #   # You'll want to customize the parameter types...
  #   parameter name: 'game_id', in: :path, type: :string, description: 'Game ID'
  #   parameter name: 'id', in: :path, type: :string, description: 'Player ID'

  #   get('show player') do
  #     tags 'Player'
  #     produces 'application/json'

  #     response(200, 'successful') do
  #       let(:game_id) { create(:game).id }
  #       let(:id) { create(:player, game: game_id).id }

  #       after do |example|
  #         example.metadata[:response][:content] = {
  #           'application/json' => {
  #             example: JSON.parse(response.body, symbolize_names: true)
  #           }
  #         }
  #       end
  #       run_test!
  #     end

  #     response(404, 'invalid game id') do
  #       let(:game_id) { create(:game).id }
  #       let(:id) { create(:player, game: game_id).id }

  #       after do |example|
  #         example.metadata[:response][:content] = {
  #           'application/json' => {
  #             example: JSON.parse(response.body, symbolize_names: true)
  #           }
  #         }
  #       end
  #       run_test!
  #     end

  #     response(404, 'invalid player id') do
  #       let(:game_id) { create(:game).id }
  #       let(:id) { create(:player, game: game_id).id }

  #       after do |example|
  #         example.metadata[:response][:content] = {
  #           'application/json' => {
  #             example: JSON.parse(response.body, symbolize_names: true)
  #           }
  #         }
  #       end
  #       run_test!
  #     end
  #   end

  #   patch('update player') do
  #     tags 'Player'
  #     response(200, 'successful') do
  #       let(:game_id) { '123' }
  #       let(:id) { '123' }

  #       after do |example|
  #         example.metadata[:response][:content] = {
  #           'application/json' => {
  #             example: JSON.parse(response.body, symbolize_names: true)
  #           }
  #         }
  #       end
  #       run_test!
  #     end
  #   end

  #   delete('delete player') do
  #     tags 'Player'
  #     response(200, 'successful') do
  #       let(:game_id) { '123' }
  #       let(:id) { '123' }

  #       after do |example|
  #         example.metadata[:response][:content] = {
  #           'application/json' => {
  #             example: JSON.parse(response.body, symbolize_names: true)
  #           }
  #         }
  #       end
  #       run_test!
  #     end
  #   end
  # end
end
