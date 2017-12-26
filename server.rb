require 'sinatra'
require 'json'

get '/poem' do
  {"foo": "bar"}.to_json
end
