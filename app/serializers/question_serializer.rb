class QuestionSerializer
  include JSONAPI::Serializer
  attributes :topic, :question_text, :question_number, :answer, :options
end