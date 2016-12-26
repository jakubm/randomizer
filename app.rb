require 'sinatra'
require "sinatra/reloader" if development?

require 'ffaker'

require 'json'

get '/name' do
  FFaker::Name.name
end

get '/name.json' do
  content_type :json
  { :name => FFaker::Name.name }.to_json
end

get '/name.json/:count' do
  content_type :json
  result = []
  params[:count].to_i.times { result << FFaker::Name.name }
  result.to_json
end
