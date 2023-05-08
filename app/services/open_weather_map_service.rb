# app/services/open_weather_map_service.rb
class OpenWeatherMapService
  include HTTParty
  base_uri 'http://api.weatherstack.com'

  def self.retrieve_forecast_data(address)
    api_key = ENV['WEATHER_STACK_API_KEY'] 

    zip_code = extract_zip_code(address)
    cache_key = zip_code || address.gsub(/[^0-9a-zA-Z\s]/, '').gsub(" ", "_")

    cache_key = "forecast_data_#{cache_key}"

    forecast_data = Rails.cache.fetch(cache_key, expires_in: 30.minutes) do
    	puts "Cache Expired: Reading from API now"
      query_params = {
        access_key: api_key,
        query: address,
        units: 'm' # Use 'm' for metric units, or 's' for scientific units
      }

      response = get('/current', query: query_params)
      if response.success?
        response.parsed_response
      else
        raise "API request failed with status #{response.code}: #{response.body}"
      end
    end

    forecast_data
  end

  def self.extract_zip_code(address)
    # Regular expression to match a five-digit US zip code pattern
    regex = /\b\d{5}\b/

    match = address.match(regex)
    return match[0] if match

    nil
  end
end
