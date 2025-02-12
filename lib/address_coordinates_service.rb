require 'json'
require 'faraday'

# Returns a pair of geocoordinates for any human-readable address
# Example usage:
# AddressCoordinatesService.new("18 Broad Street, New York, NY 10005").call
# Returns an object with latitude and longitude properties:
# {
#   latitude: "40.71",
#   longitude: "74.01"
# }

class AddressCoordinatesService
    BASE_URL = 'https://geocode.maps.co/'.freeze

    def initialize(address)
        @address = address
        @client = Faraday.new(
            url: BASE_URL
        )
    end

    def call
        result = @client.get(path)
        parse_response(result)
    end

    private

    def parse_response(raw_response)
        json_response = JSON.parse(raw_response.env.response_body)[0]
        return {
            latitude: sprintf("%0.02f", json_response['lat']),
            longitude: sprintf("%0.02f", json_response['lon'])
        }
    end

    def path
        "search?q=#{@address}&api_key=#{api_key}"
    end

    def api_key
        ENV['GEOCODE_API_KEY']
    end
end
