class QuestionService 
  attr_reader :api_url, :options, :query

  def initialize(number, topic)
    @query = "Write #{number} trivia questions about #{topic}, and phrase the answers in two words or less. Return 1 correct answer and 3 incorrect answers. Format message['content'] as JSON with id and a key named correct_answer associated with the string of the correct answer and another key named options associated to an array of the 4 strings of the generated options"

    @api_url = 'https://api.openai.com/v1/chat/completions'

    @options = {
      'Content-Type' => 'application/json',
      'Authorization' => Rails.application.credentials.open_ai_key
    }
  end

  def call
    body = {
      model: 'gpt-3.5-turbo',
      messages: [ { role: 'user', content: @query,
      format: "json" }]
    }

    response = connection.post(@api_url, body.to_json, @options)

    unless response.success?
      raise "Error: #{JSON.parse(response.body)['error']['message']}"
    end

    response.body

    rescue StandardError => e
      raise "Error calling OpenAI API: #{e.message}"
    nil
  end

  def connection
    Faraday.new do |faraday|
      faraday.request :json
      faraday.response :json, content_type: /\bjson$/
      faraday.adapter Faraday.default_adapter
    end
  end
end
