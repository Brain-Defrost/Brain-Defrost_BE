class PlayerSerializer
  include JSONAPI::Serializer
  attributes :display_name, :answers_correct, :answers_incorrect
end