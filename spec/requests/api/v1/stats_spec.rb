# require 'swagger_helper'

# RSpec.describe 'Stats API', type: :request do

#   path '/api/v1/games/{game_id}/stats' do
#     parameter name: :game_id, in: :path, type: :string, description: 'Game ID'

#     get("List a game's stats") do
#       tags 'Stats'
#       produces 'application/json'

#       response(200, 'successful') do
#         let(:game_id) { create(:game).id }
#         let(:stat) { create(:stat, game: game_id)}

#         schema({
#           type: :object,
#           properties: {
#             data: {
#               type: :object,
#               properties: {
#                 id: { type: :integer },
#                 type: { type: :string },
#                 attributes: {
#                   type: :object,
#                   properties: {
#                     avg_correct_answers: { type: :number, format: :float, required: true }
#                   }
#                 },
#                 relationships: {
#                   type: :object,
#                   properties: {
#                     games: {
#                       type: :object,
#                       properties: {
#                         data: {
#                           type: :array,
#                           items: {
#                             type: :object,
#                             properties: {
#                               id: { type: :integer},
#                               type: { type: :string },
#                               attributes: {
#                                 type: :object,
#                                 properties: {
#                                   link: { type: :string },
#                                   started: { type: :boolean },
#                                   number_of_questions: { type: :integer },
#                                   number_of_players: { type: :integer },
#                                   topic: { type: :string },
#                                   time_limit: { type: :integer }
#                                 }
#                               }
#                             }
#                           }
#                         }
#                       }
#                     },
#                     players: {
#                       type: :object,
#                       properties: {
#                         data: {
#                           type: :array,
#                           items: {
#                             type: :object,
#                             properties: {
#                               id: { type: :integer},
#                               type: { type: :string },
#                               attributes: {
#                                 type: :object,
#                                 properties: {
#                                   display_name: { type: :string },
#                                   answers_correct: { type: :integer },
#                                   answers_incorrect: { type: :integer }
#                                 }
#                               }
#                             }
#                           }
#                         }
#                       }
#                     }
#                   }
#                 }
#               }
#             }
#           }
#         })

#         run_test! do |example|
#           expect(response).to have_http_status(200)
#         end
#       end

#       response(404, 'Game ID not found') do
#         let(:id) { -1 }

#         run_test! do |example|
#           expect(response.status).to eq 404

#           error = JSON.parse(response.body, symbolize_names: true)[:error]
#           expect(error[:message]).to eq "Couldn't find Game with 'id'=-1"
#         end
#       end
#     end
#   end
# end
