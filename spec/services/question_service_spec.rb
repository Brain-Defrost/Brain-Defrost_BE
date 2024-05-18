require 'rails_helper'

RSpec.describe QuestionService do
  describe ".create_questions_for(game)" do
    let!(:game) { {topic: "service oriented architecture", number_of_questions: "5"} }

    context 'happy path' do
      it "returns trivia questions given a game topic and question count", :vcr do
        questions_data = QuestionService.create_questions_for(game)

        if questions_data.include?(:data)
          check_hash_structure(questions_data, :data, Array)

          questions_data[:data].each do |data|
            check_hash_structure(data, :attributes, Hash)
            expect(data[:attributes]).to include(:question_text, :question_number, :answer, :options)
            expect(data[:attributes].values.flatten).to all(be_a(String))
          end
        else
          expect(questions_data[:error]).to be_a(Hash)
          check_hash_structure(questions_data, :error, Hash)
          check_hash_structure(questions_data[:error], :message, String)
        end
      end
    end
  end
end