require 'swagger_helper'
require 'securerandom'

RSpec.describe 'Game API', type: :request do

    path '/api/v1/games' do

      post('Create a new trivia game') do
        tags 'Game'
        consumes 'application/json'
        produces 'application/json'

        parameter name: :params, in: :body, required: true, schema: {
          type: :object,
          properties: {
            topic: { type: :string, required: true },
            number_of_questions: { type: :integer, required: true },
            time_limit: { type: :integer, required: true },
            number_of_players: { type: :integer, required: true },
            display_name: { type: :string, required: true },
            link: { type: :string } # remove later
          }
        }

        response(201, 'successful') do
          let(:params) { {
            topic: "music",
            number_of_questions: 8,
            time_limit: 30,
            number_of_players: 7,
            display_name: "trivia_genius",
            link: "www.example.com/#{SecureRandom.hex(5)}" # remove later
          } }

          schema({
            type: :object,
            properties: {
              data: {
                type: :object,
                properties: {
                  id: { type: :string },
                  type: { type: :string },
                  attributes: {
                    type: :object,
                    properties: {
                      link: { type: :string, required: true },
                      started: { type: :boolean },
                      number_of_questions: { type: :integer },
                      number_of_players: { type: :integer },
                      topic: { type: :string },
                      time_limit: { type: :integer }
                    }
                  },
                  relationships: {
                    type: :object,
                    properties: {
                      players: {
                        type: :object,
                        properties: {
                          data: {
                            type: :array,
                            items: {
                              type: :object,
                              properties: {
                                id: { type: :string },
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
                      },
                      questions: {
                        type: :object,
                        properties: {
                          data: {
                            type: :array,
                            items: {
                              type: :object,
                              properties: {
                                id: { type: [:string, :null] },
                                type: { type: :string },
                                attributes: {
                                  type: :object,
                                  properties: {
                                    topic: { type: :string },
                                    question_text: { type: :string },
                                    question_number: { type: :integer },
                                    answer: { type: :string },
                                    options: {
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
            expect(response.status).to eq 201
            parsed_data = JSON.parse(response.body, symbolize_names: true)[:data]
            expect(parsed_data[:id].to_i).to eq Game.last.id
            expect(parsed_data[:type]).to eq "game"
            expect(parsed_data[:attributes][:display_name]).to eq "trivia-ninja"
            expect(parsed_data[:attributes][:answers_correct]).to eq 0
            expect(parsed_data[:attributes][:answers_incorrect]).to eq 0
            expect(response.body)
          end
        end
      end
    end

    path '/api/v1/games/{id}' do
      parameter name: 'id', in: :path, type: :string, description: 'Game ID'

      get('show game') do
        # parameter name: 'id', in: :path, type: :integer, description: 'Game ID'
        tags 'Game'
        produces 'application/json'

        response(200, 'successful') do
          schema({
            type: :object,
            properties: {
              data: {
                type: :object,
                properties: {
                  id: { type: :string },
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
                  },
                  relationships: {
                    type: :object,
                    properties: {
                      players: {
                        type: :object,
                        properties: {
                          data: {
                            type: :array,
                            items: {
                              type: :object,
                              properties: {
                                id: { type: :string },
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

          let(:game_1) { create(:game) }
          let(:player_1) { create(:player, game: game_1)}
          let(:player_2) { create(:player, game: game_1)}
          let(:id) { game_1.id }

          run_test! do |response|
            expect(response).to have_http_status(200)
          end
        end

      patch('update game') do
        tags 'Game'
        consumes 'application/json'
        produces 'application/json'

        parameter name: :params, in: :body, schema: {
          type: :object,
          properties: {
            type: :boolean, required: true
          }
        }

        response(200, 'successful') do
          let(:id) { create(:game, started: false).id }
          let(:params) { { started: true } }

          schema({ 
            type: :object,
            properties: {
              data: {
                type: :object,
                properties: {
                  id: { type: :string },
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
          })

          run_test! do |response|
            expect(response.status).to eq 200
            parsed_data = JSON.parse(response.body, symbolize_names: true)[:data]
            expect(parsed_data[:id].to_i).to eq(id)
            expect(parsed_data[:attributes][:started]).to eq true
          end
        end
      end
    end
  end
end
