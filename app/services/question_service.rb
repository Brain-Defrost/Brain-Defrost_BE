class QuestionService 
  attr_reader :api_url, :options, :query

  def initialize(number, topic)
    @query = "Write #{number} trivia questions and write the answer below each question. Make the questions about #{topic}, and phrase the answers in two words or less"

    @api_url = 'https://api.openai.com/v1/chat/completions'

    @options = {
      'Content-Type' => 'application/json',
      'Authorization' => Rails.application.credentials.chatgpt_api_key
    }
  end

  def call
    body = {
      model: 'gpt-3.5-turbo', #Model can be change
      messages: [
        { 
          role: 'user', 
          content: @query 
        }
      ]
    }

    response = connection.post(@api_url, body.to_json, @options)

    unless response.success?
      raise "Error: #{response.body['error']['message']}"
    end

    response.body['choices'][0]['message']['content']

    rescue StandardError => e
      puts "Error calling OpenAI API: #{e.message}"
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
