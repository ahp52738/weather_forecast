## Project Name
Weather Forecast

## Description
This Rails application retrieves weather forecast data based on user input and caches the data for subsequent requests. It uses the OpenWeatherMap API to fetch the forecast data.

Setup
Clone the repository to your local machine:

```git clone https://github.com/ahp52738/weather_forecast.git/```

Change into the project directory:

cd weather_forecast

Install the required gems:

bundle install

Set up the database:

```rails db:create
   rails db:migrate
```


## Configure the OpenWeatherMap API key:

Open the file .env (create it if it doesn't exist).

Add the following line, replacing <your-api-key> with your actual WeatherStack API key:

WEATHER_STACK_API_KEY: <your-api-key>
Start the Rails server:


```rails server```


## Running the Tests
This project uses RSpec for testing. To run the test suite, execute the following command:


```bundle exec rspec```

This will run all the tests located in the spec directory and display the test results.
