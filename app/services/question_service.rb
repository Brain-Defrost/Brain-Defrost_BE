require 'faraday/retry'

class QuestionService
  def self.create_questions_for(game)
    post_url("/api/v1/questions", game)
    @parsed_json
  end

  def self.post_url(url, params)
    response = conn.post(url, JSON.generate(params))
    @parsed_json = JSON.parse(response.body, symbolize_names: true)
  end

  def self.conn
    Faraday.new(url: "https://brain-defrost-be-questions.onrender.com") do |faraday|
      faraday.request :retry, max: 1, interval: 2, exceptions: [Faraday::TimeoutError]
    end
  end
end
