require 'rails_helper'

RSpec.describe GetForecastService do
  describe '#call' do
    let(:service) { described_class.new(forecast_url) }
    let(:forecast_url) { 'https://api.weather.gov/gridpoints/EAX/52,33/forecast' }

    context 'with valid forecast URL' do
      let(:expected_forecast) do
        [
          {
            temperature: 25,
            day_of_week: 'This Afternoon',
            details: 'A chance of snow showers. Mostly cloudy. High near 25, with temperatures falling to around 23 in the afternoon. Northeast wind around 10 mph.',
            icon_url: '/weather/snow.png'
          }
        ]
      end

      it 'returns formatted forecast data' do
        VCR.use_cassette('get_forecast_success') do
          expect(service.call.first.keys).to match_array(
            [:date, :day_of_week, :details, :icon_url, :is_day, :precip_percent, :summary, :temperature]
          )
        end
      end
    end

    context 'with invalid forecast URL' do
      let(:forecast_url) { 'https://api.weather.gov/invalid/url' }

      it 'raises an error' do
        VCR.use_cassette('get_forecast_invalid_url') do
          expect { service.call }.to raise_error(StandardError)
        end
      end
    end
  end
end