Rails.application.routes.draw do
  # Defines the root path route ("/")
  root 'weather#index'
  get '/query', to: "weather#query"
  #get '/show', to: 'weather#show'
end
