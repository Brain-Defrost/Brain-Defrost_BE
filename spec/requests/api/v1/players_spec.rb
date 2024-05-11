require 'swagger_helper'

RSpec.describe 'api/v1/players', type: :request do

  path '/api/v1/games/{game_id}/players' do
    # You'll want to customize the parameter types...
    parameter name: 'game_id', in: :path, type: :string, description: 'game_id'

    post('create player') do
      response(200, 'successful') do
        let(:game_id) { '123' }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end
  end

  path '/api/v1/games/{game_id}/players/{id}' do
    # You'll want to customize the parameter types...
    parameter name: 'game_id', in: :path, type: :string, description: 'game_id'
    parameter name: 'id', in: :path, type: :string, description: 'id'

    get('show player') do
      response(200, 'successful') do
        let(:game_id) { '123' }
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end

    patch('update player') do
      response(200, 'successful') do
        let(:game_id) { '123' }
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end

    put('update player') do
      response(200, 'successful') do
        let(:game_id) { '123' }
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end

    delete('delete player') do
      response(200, 'successful') do
        let(:game_id) { '123' }
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end
  end
end
