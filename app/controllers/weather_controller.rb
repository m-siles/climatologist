class WeatherController < ApplicationController
    def query
        # whitelist relevant variable
        params.permit(:address)

        coordinates = AddressCoordinatesService.new(params[:address]).call
        cache_key = generate_cache_key(coordinates)

        # skip weather calls if we've cached it
        @forecasts = Rails.cache.fetch(cache_key, expires_in: 30.minutes) do
            forecast_url = GetForecastUrlService.new(**coordinates).call
            GetForecastService.new(forecast_url).call
        end
        render 'query'
    end

    def show
        @forecast_days = session[:forecast_days]
    end

    private

    def generate_cache_key(coordinates)
        "coordinates:#{coordinates[:latitude]},#{coordinates[:longitude]}:hour:#{Time.current.strftime('%Y%m%d%H')}"
    end
end