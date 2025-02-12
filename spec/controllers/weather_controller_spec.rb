require 'rails_helper'

RSpec.describe WeatherController, type: :controller do
  describe 'GET #query' do
    let(:valid_address) { '123 Main St, Anytown, USA' }
    let(:coordinates) { { latitude: 40.7128, longitude: -74.0060 } }
    let(:forecast_url) { 'https://api.weather.gov/gridpoints/TOP/31,80/forecast' }
    let(:mock_forecasts) { [{ temperature: 72, day_of_week: 'Monday', details: 'Sunny' }] }

    context 'with valid address' do
      before do
        allow_any_instance_of(AddressCoordinatesService)
          .to receive(:call)
          .and_return(coordinates)

        allow_any_instance_of(GetForecastUrlService)
          .to receive(:call)
          .and_return(forecast_url)

        allow_any_instance_of(GetForecastService)
          .to receive(:call)
          .and_return(mock_forecasts)
      end

      it 'returns a successful response' do
        get :query, params: { address: valid_address }
        expect(response).to be_successful
      end

      it 'assigns @forecasts' do
        get :query, params: { address: valid_address }
        expect(assigns(:forecasts)).to eq(mock_forecasts)
      end

      it 'renders the query template' do
        get :query, params: { address: valid_address }
        expect(response).to render_template('query')
      end
    end
  end
end