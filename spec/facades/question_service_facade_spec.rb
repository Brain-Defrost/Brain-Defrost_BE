require 'rails_helper'

RSpec.describe QuestionServiceFacade do
  before do
    @game = Game.create!({link: "www.example.com/#{SecureRandom.hex(5)}", number_of_questions: 8, number_of_players: 7, topic: "music", time_limit: 30})

    @json_music_questions_3= File.read("spec/fixtures/question_service_3.json")
    @json_music_questions_2= File.read("spec/fixtures/question_service_2.json")
    @json_music_questions_1= File.read("spec/fixtures/question_service_1.json")

    @service_responses = [@json_music_questions_1, @json_music_questions_2, @json_music_questions_3]
  end

  describe '#parse_questions' do
    it 'returns parsed data in format useful to create Question objects' do
      @service_responses.each do |service_response|
        parsed_data = QuestionServiceFacade.parse_questions(service_response)

        expect(parsed_data).to be_an(Array)
        parsed_data.each do |data|
          check_hash_structure(data, 'id', Integer)
          check_hash_structure(data, 'topic', String)
          check_hash_structure(data, 'question_text', String)
          check_hash_structure(data, 'correct_answer', String)
          check_hash_structure(data, 'options', Array)
        end
      end
    end
  end   

  describe '#get_questions' do
    it 'returns question objects in an array' do
      #Format 1
      allow_any_instance_of(QuestionService).to receive(:call).and_return(@json_music_questions_1)

      questions = QuestionServiceFacade.get_questions(@game)

      expect(questions).to be_an(Array)
      questions.each { |question| expect(question).to be_a(Question) }

      #Format 2
      allow_any_instance_of(QuestionService).to receive(:call).and_return(@json_music_questions_2)

      questions = QuestionServiceFacade.get_questions(@game)

      expect(questions).to be_an(Array)
      questions.each { |question| expect(question).to be_a(Question) }

      #Format 3
      allow_any_instance_of(QuestionService).to receive(:call).and_return(@json_music_questions_3)

      questions = QuestionServiceFacade.get_questions(@game)

      expect(questions).to be_an(Array)
      questions.each { |question| expect(question).to be_a(Question) }
    end
  end
end