class OracleController < ApplicationController
  skip_before_action :verify_authenticity_token
  def index
    response = call_openai_api
    render json: response
  end

  private

  def call_openai_api
    conn = Faraday.new(url: 'https://api.openai.com/v1/') do |faraday|
      faraday.response :logger do | logger |
        def logger.debug *args; end
      end
      faraday.headers['Content-Type'] = 'application/json'
    #   faraday.headers['Authorization'] = "Bearer #{ENV['OPENAI_API_KEY']}"
      faraday.headers['Authorization'] = "Bearer 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"

      faraday.adapter Faraday.default_adapter
    end

    payload = {
      model: "gpt-3.5-turbo",
      "messages": [
        {
            "role": "user",
            "content": "Give me a prompt to use for jazz improvisation."
        }
      ]
    }

    response = conn.post('chat/completions') do |req|
      req.body = payload.to_json
    end

    JSON.parse(response.body)
  end
end
