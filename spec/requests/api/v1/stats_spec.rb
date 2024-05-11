require 'swagger_helper'

RSpec.describe 'api/v1/stats', type: :request do

  path '/api/v1/games/{game_id}/stats' do
    # You'll want to customize the parameter types...
    parameter name: 'game_id', in: :path, type: :string, description: 'game_id'

    get('show stat') do
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
end
