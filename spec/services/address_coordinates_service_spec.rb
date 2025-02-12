require 'rails_helper'

RSpec.describe AddressCoordinatesService do
  describe '#call' do
    let(:service) { described_class.new(address) }
    let(:address) { '123 Main St, Kansas City, MO' }

    context 'with valid address' do
      let(:expected_coordinates) { { latitude: '39.05', longitude: '-94.59' } }

      it 'returns coordinates for the address' do
        VCR.use_cassette('geocoding_valid_address') do
          expect(service.call).to eq(expected_coordinates)
        end
      end
    end

    context 'with invalid address' do
      let(:address) { 'Invalid Address 123456' }

      it 'raises an error' do
        VCR.use_cassette('geocoding_invalid_address') do
          expect { service.call }.to raise_error(StandardError)
        end
      end
    end
  end
end