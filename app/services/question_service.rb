class QuestionService
  def self.create_questions_for(game)
    post_url("/api/v1/questions", game)
    @parsed_json
  end

  def self.post_url(url, params)
    response = conn.post(url, params) do |req|
      req.retry(max: 1, interval: 2) { |exception|
      exception.is_a?(Faraday::TimeoutError)
    }
    end

    @parsed_json = JSON.parse(response.body, symbolize_names: true)
  end

  def self.conn
    Faraday.new(url: "https://brain-defrost-be-questions.onrender.com")
  end
end
