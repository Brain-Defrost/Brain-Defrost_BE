# require 'swagger_helper'

# RSpec.describe 'Stats API', type: :request do

#   path '/api/v1/games/{game_id}/stats' do
#     # You'll want to customize the parameter types...
#     parameter name: 'game_id', in: :path, type: :string, description: 'Game ID'

#     get('show stat') do
#       tags 'Stats'
#       response(200, 'successful') do
#         let(:game_id) { create(:game).id }
#         let(:stat) { create(:stat, game: game_id)}

#         schema type: 'object',
#           properties: {
#             id: { type: 'string' },
#             avg_correct_answers: { type: 'number', format: 'float' }
#           }

#         run_test! do |example|
#           get "/api/v1/games/#{game_id}/stats"
#           require 'pry'; binding.pry
#           expect(response).to have_http_status(200)
#         end
#       end
#     end
#   end
# end
