Rails.application.routes.draw do
  root 'forecasts#index'
  get 'forecast', to: 'forecasts#show'
end
