require 'rails_helper'

RSpec.describe GetForecastUrlService do
  describe '#call' do
    let(:service) { described_class.new(latitude: latitude, longitude: longitude) }
    let(:latitude) { 39.0997 }
    let(:longitude) { -94.5786 }
    let(:expected_url) { '/gridpoints/EAX/44,51/forecast' }

    it 'returns the correct forecast URL for given coordinates' do
      VCR.use_cassette('get_forecast_url_success') do
        expect(service.call).to eq(expected_url)
      end
    end

    context 'with invalid coordinates' do
      let(:latitude) { 200 } # Invalid latitude
      let(:longitude) { 0 }

      it 'raises an error' do
        VCR.use_cassette('get_forecast_url_invalid_coordinates') do
          expect { service.call }.to raise_error(StandardError)
        end
      end
    end
  end
end