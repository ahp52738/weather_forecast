class ForecastsController < ApplicationController
  def index
  end

  def show
    address = params[:address]
    begin
      @forecast_data = OpenWeatherMapService.retrieve_forecast_data(address)
    rescue StandardError => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end
end