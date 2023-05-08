require 'rails_helper'

RSpec.describe OpenWeatherMapService do
  describe '.retrieve_forecast_data' do
    let(:api_key) { ENV['WEATHER_STACK_API_KEY']  }
    let(:address) { 'New York, NY' }
    let(:zip_code) { '10001' }
    let(:cache_key) { "forecast_data_#{zip_code}" }

    context 'when the forecast data is not cached' do
      let(:response_body) do
        {
          'current' => {
            'temperature' => 15,
            'weather_descriptions' => ['Partly cloudy'],
            'wind_speed' => 10,
            # ...
          }
        }
      end

      before do
        allow(OpenWeatherMapService).to receive(:extract_zip_code).and_return(zip_code)
        allow(Rails.cache).to receive(:fetch).with(cache_key, expires_in: 30.minutes).and_yield
        allow(OpenWeatherMapService).to receive(:get).and_return(
          double(success?: true, parsed_response: response_body)
        )
      end

      it 'returns the forecast data from the API' do
        forecast_data = OpenWeatherMapService.retrieve_forecast_data(address)
        expect(forecast_data).to eq(response_body)
      end

      it 'fetches and caches the forecast data' do
        expect(Rails.cache).to receive(:fetch).with(cache_key, expires_in: 30.minutes).and_yield
        OpenWeatherMapService.retrieve_forecast_data(address)
      end
    end

    context 'when the forecast data is already cached' do
      let(:cached_data) do
        {
          'current' => {
            'temperature' => 20,
            'weather_descriptions' => ['Sunny'],
            'wind_speed' => 5,
            # ...
          }
        }
      end

      before do
        allow(OpenWeatherMapService).to receive(:extract_zip_code).and_return(zip_code)
        allow(Rails.cache).to receive(:fetch).with(cache_key, expires_in: 30.minutes).and_return(cached_data)
      end

      it 'returns the cached forecast data' do
        forecast_data = OpenWeatherMapService.retrieve_forecast_data(address)
        expect(forecast_data).to eq(cached_data)
      end

      it 'does not fetch the forecast data from the API' do
        OpenWeatherMapService.retrieve_forecast_data(address)
      end
    end

    context 'when the API request fails' do
      before do
        allow(OpenWeatherMapService).to receive(:extract_zip_code).and_return(zip_code)
        allow(Rails.cache).to receive(:fetch).with(cache_key, expires_in: 30.minutes).and_yield
        allow(OpenWeatherMapService).to receive(:get).and_return(
          double(success?: false, code: 500, body: 'Internal Server Error')
        )
      end

      it 'raises an exception' do
        expect { OpenWeatherMapService.retrieve_forecast_data(address) }.to raise_error(RuntimeError)
      end
    end
  end
end
