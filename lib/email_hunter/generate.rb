require 'faraday'
require 'json'

API_GENERATE_URL = 'https://api.emailhunter.co/v1/generate?'

module EmailHunter
  class Generate
    attr_reader :status, :email, :score

    def initialize(company, domain, first_name, last_name, key)
      @first_name = first_name
      @last_name = last_name
      @domain = domain
      @company = company
      @key = key
    end

    def hunt
      response = apiresponse
      Struct.new(*response.keys).new(*response.values) unless response.empty?
    end

    private

    def apiresponse
      url = URI.parse(URI.encode("#{API_GENERATE_URL}domain=#{@domain}&company=#{@company}&first_name=#{@first_name}&last_name=#{@last_name}&api_key=#{@key}"))
      response = Faraday.new(url).get
      response.success? ? JSON.parse(response.body, {symbolize_names: true}) : []
    end
  end
end
