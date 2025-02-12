require 'json'
require 'faraday'
require 'date'

# Retrieves a forecast based on local data from the National Weather Service
class GetForecastService
    BASE_URL = 'https://api.weather.gov/'.freeze

    def initialize(forecast_path)
        @forecast_path = forecast_path
        @client = Faraday.new(
            url: BASE_URL,
            headers: { 'Accept' => 'application/geo+json'}
        )
    end

    def call
        forecast_request = @client.get(@forecast_path)
        forecasts = parse_response(forecast_request)
        
    end

    private

    # Typical incoming format for ['properties']['periods']:
    # {"number"=>9,
    # "name"=>"Sunday",
    # "startTime"=>"2025-02-09T06:00:00-06:00",
    # "endTime"=>"2025-02-09T18:00:00-06:00",
    # "isDaytime"=>true,
    # "temperature"=>36,
    # "temperatureUnit"=>"F",
    # "temperatureTrend"=>"",
    # "probabilityOfPrecipitation"=>{"unitCode"=>"wmoUnit:percent", "value"=>nil},
    # "windSpeed"=>"5 to 10 mph",
    # "windDirection"=>"NE",
    # "icon"=>"https://api.weather.gov/icons/land/day/bkn?size=medium",
    # "shortForecast"=>"Partly Sunny",
    # "detailedForecast"=>"Partly sunny, with a high near 36. Northeast wind 5 to 10 mph."}
    def parse_response(raw_response)
        forecast_json = JSON.parse(raw_response.env.response_body)
        json_forecasts = forecast_json['properties']['periods']
        forecasts = json_forecasts.map do |forecast|
            {
                day_of_week: forecast['name'],
                summary: forecast['shortForecast'],
                details: forecast['detailedForecast'],
                temperature: forecast['temperature'],
                precip_percent: forecast['probabilityOfPrecipitation']['value'],
                date: DateTime.parse(forecast['startTime']),
                icon_url: forecast['icon'],
                is_day: forecast['isDaytime']
            }
        end
    end
end
