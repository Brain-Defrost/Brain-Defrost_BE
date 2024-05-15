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
                  id: { type: :integer },
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

          run_test! vcr: true do |example|
            expect(response.status).to eq 201

            parsed_data = JSON.parse(response.body, symbolize_names: true)[:data]
            expect(parsed_data[:id].to_i).to eq Game.last.id
            expect(parsed_data[:type]).to eq "game"
            expect(parsed_data[:attributes][:started]).to be false

            players = parsed_data[:relationships][:players][:data]
            expect(players.size).to eq 1
            expect(players[0][:attributes][:display_name]).to eq params[:display_name]

            questions = parsed_data[:relationships][:questions][:data]
            expect(questions.size).to eq params[:number_of_questions]
          end
        end
      end
    end

    path '/api/v1/games/{id}' do

      get('show game') do
        tags 'Game'
        produces 'application/json'
        parameter name: :id, in: :path, type: :integer, description: 'Game ID'

        response(200, 'successful') do
          let(:game_1) { create(:game) }
          before { 2.times do create(:player, game_id: game_1.id) end}
          let(:id) { game_1.id }

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
            expect(response).to have_http_status(200)

            parsed_data = JSON.parse(response.body, symbolize_names: true)[:data]
            expect(parsed_data[:id].to_i).to eq id
            expect(parsed_data[:type]).to eq "game"

            players = parsed_data[:relationships][:players][:data]
            expect(players.size).to eq 2

            questions = parsed_data[:relationships][:questions][:data]
            expect(questions.size).to eq 0
          end
        end

      patch('update game') do
        tags 'Game'
        consumes 'application/json'
        produces 'application/json'
        parameter name: :id, in: :path, type: :integer, description: 'Game ID'

        parameter name: :params, in: :body, schema: {
          type: :object,
          properties: {
            type: :boolean, required: true
          }
        }

        response(200, 'successful') do
          let(:game_2) { create(:game, started: false) }
          before { 2.times do create(:player, game_id: game_2.id) end}
          let(:id) { game_2.id }
          let(:params) { { started: true } }

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
            expect(response.status).to eq 200

            parsed_data = JSON.parse(response.body, symbolize_names: true)[:data]
            expect(parsed_data[:id].to_i).to eq id
            expect(parsed_data[:attributes][:started]).to eq params[:started]

            players = parsed_data[:relationships][:players][:data]
            expect(players.size).to eq 2

            questions = parsed_data[:relationships][:questions][:data]
            expect(questions.size).to eq 0
          end
        end
      end
    end
  end
end
