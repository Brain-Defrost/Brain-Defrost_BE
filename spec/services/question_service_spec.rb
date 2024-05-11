require 'rails_helper'

RSpec.describe QuestionService do
  before(:each) do
    number = 8
    topic = "music"

    @question_service = QuestionService.new(number, topic)

    json_music_questions = File.read("spec/fixtures/question_service_1.json")

    allow_any_instance_of(QuestionService).to receive(:call).and_return(json_music_questions)
  end
  describe '#initialize' do
    it 'exists and populates attributes correctly' do
      expect(@question_service).to be_a(QuestionService)
      expect(@question_service.query).to eq("Write 8 trivia questions about music, and phrase the answers in two words or less. Return 1 correct answer and 3 incorrect answers. Format message['content'] as JSON with id and a key named correct_answer associated with the string of the correct answer and another key named options associated to an array of the 4 strings of the generated options")
    end
  end

  describe '#call' do
    it 'returns generated trivia questions' do
      service_response = @question_service.call
      json_response = JSON.parse(service_response)

      expect{ service_response }.not_to raise_error
      check_hash_structure(json_response, 'id', String)
      check_hash_structure(json_response, 'object', String)
      check_hash_structure(json_response, 'created', Integer)
      check_hash_structure(json_response, 'model', String)
      check_hash_structure(json_response, 'usage', Hash)
      check_hash_structure(json_response, 'choices', Array)
      check_hash_structure(json_response['choices'].first, 'message', Hash)
      check_hash_structure(json_response['choices'].first['message'], 'content', String)
    end
  end
end