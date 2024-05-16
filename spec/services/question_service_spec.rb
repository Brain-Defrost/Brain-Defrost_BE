require 'rails_helper'

RSpec.describe QuestionService do
  before do
    number = 8
    topic = "music"

    @question_service = QuestionService.new(number, topic)
  end
  describe '#initialize' do
    it 'exists and populates attributes correctly' do
      expect(@question_service).to be_a(QuestionService)
      expect(@question_service.query).to eq("Write 8 trivia questions about music, and phrase the answers in two words or less. Return 1 correct answer and 3 incorrect answers. Format JSON with id and a key named topic associated to the topic, a key named question_text associated to the question, a key named correct_answer associated with the string of the correct answer and another key named options associated to an array of the 4 strings of the generated options")
    end
  end

  describe '#call' do
    context 'happy path' do
      it 'returns generated trivia questions', :vcr do
        service_response = @question_service.call

        expect{ service_response }.not_to raise_error
        check_hash_structure(service_response, 'id', String)
        check_hash_structure(service_response, 'object', String)
        check_hash_structure(service_response, 'created', Integer)
        check_hash_structure(service_response, 'model', String)
        check_hash_structure(service_response, 'usage', Hash)
        check_hash_structure(service_response, 'choices', Array)
        check_hash_structure(service_response['choices'].first, 'message', Hash)
        check_hash_structure(service_response['choices'].first['message'], 'content', String)
      end
    end

    context 'when the API request fails' do
      it 'raises an error' do
        stub_request(:post, 'https://api.openai.com/v1/chat/completions')
          .to_return(status: 500)
        
        expect { @question_service.call }.to raise_error(StandardError, /Error calling OpenAI API/)
      end
    end

    context 'when the API returns an error response' do
      it 'raises an error with the message from the API' do
        error_message = 'API error message here'

        stub_request(:post, 'https://api.openai.com/v1/chat/completions')
          .to_return(status: 400, body: { error: { message: error_message } }.to_json)
        
        expect { @question_service.call }.to raise_error(RuntimeError, /Error: #{error_message}/)
      end
    end
  end
end