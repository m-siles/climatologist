require 'json'
require 'faraday'

class GetForecastUrlService
    BASE_URL = 'https://api.weather.gov/'.freeze

    def initialize(latitude:, longitude:)
        @latitude = latitude
        @longitude = longitude
        @client = Faraday.new(
            url: BASE_URL,
            headers: { 'Accept' => 'application/geo+json'}
        )
    end

    def call
        forecast_url_request = @client.get(path)
        parse_response(forecast_url_request)
    end

    private

    def parse_response(raw_response)
        coordinate_json = JSON.parse(raw_response.env.response_body)
        forecast_uri = coordinate_json['properties']['forecast']
        forecast_path = URI(forecast_uri).path
    end

    def path
        "/points/#{@latitude},#{@longitude}"
    end
end
