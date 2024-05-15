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

      # response(400, 'display name blank') do
      #   # let(:game_id) { create(:game).id }
      #   let(:params) { {display_name: ''} }

      #   after do |example|
      #     example.metadata[:response][:content] = {
      #       'application/json' => {
      #         example: JSON.parse(response.body, symbolize_names: true)
      #       }
      #     }
      #   end
      #   run_test!
      # end

      # response(404, 'invalid game id') do
      #   # let(:game_id) { create(:game).id }
      #   let(:id) { -1 }

      #   after do |example|
      #     example.metadata[:response][:content] = {
      #       'application/json' => {
      #         example: JSON.parse(response.body, symbolize_names: true)
      #       }
      #     }
      #   end
      #   run_test!
      # end

      # response(422, 'display name taken') do
      #   # let(:game_id) { create(:game).id }
      #   # let(:player) { create(:player, display_name: 'trivia-ninja') }
      #   let(:params) { {display_name: 'trivia-ninja'} }

      #   after do |example|
      #     example.metadata[:response][:content] = {
      #       'application/json' => {
      #         example: JSON.parse(response.body, symbolize_names: true)
      #       }
      #     }
      #   end
      #   run_test!
      # end
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
