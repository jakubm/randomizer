require 'sinatra'
require 'sinatra/reloader' if development?

require 'ffaker'

require 'json'
require 'socket'

set :bind, '0.0.0.0'
set :port, 8080

get '/' do
  erb :home
end

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

get '/airline.json' do
  content_type :json
  { :name => FFaker::Airline.name }.to_json
end

get '/airline.json/:count' do
  content_type :json
  result = []
  params[:count].to_i.times { result << FFaker::Airline.name }
  result.to_json
end

get '/flightnumber.json' do
  content_type :json
  { :flightNumber => FFaker::Airline.flight_number }.to_json
end

get '/flightnumber.json/:count' do
  content_type :json
  result = []
  params[:count].to_i.times { result << FFaker::Airline.flight_number }
  result.to_json
end

def faker_modules
  FFaker.constants.map do |const|
    mod = FFaker.const_get(const)
    next unless mod.is_a?(Module)
    next if mod == FFaker::ArrayUtils
    next if mod == FFaker::ModuleUtils
    next if mod == FFaker::RandomUtils
    next if mod == FFaker::Random
    mod
  end.compact
end

def ffaker_module
  faker_modules.select { |m| m.to_s.downcase.end_with?(params[:module]) }.first
end

get '/ffaker/:module/all/:count' do
  content_type :json
  result = []
  params[:count].to_i.times do
    obj = {}
    ffaker_module.instance_methods.each do |m|
      obj["#{m.to_s}"] = ffaker_module.send(m)
    end
    result << obj
  end
  result.to_json
end

get '/ffaker/:module/:method/:count' do
  content_type :json
  result = []
  params[:count].to_i.times { result << ffaker_module.send(params[:method]) }
  result.to_json
end

get '/ffaker/:module/all' do
  content_type :json
  result = {}
  ffaker_module.instance_methods.each do |m|
    result["#{m.to_s}"] = ffaker_module.send(m)
  end
  result.to_json
end

get '/ffaker/:module/:method' do
  content_type :json
  { "#{params[:method]}": ffaker_module.send(params[:method])}.to_json
end

get '/ffaker/:module' do
  content_type :json
  ffaker_module.instance_methods.to_json
end

get '/ffaker/' do
  content_type :json
  faker_modules.to_json
end

__END__
@@home
<!doctype html>
<html lang="en">
<head>
  <title>Randomizer By Sinatra</title>
  <meta charset="utf-8">
</head>
<body>
  <header>
    <h1>Randomizer By Sinatra</h1>
    <nav>
      <h2>Names</h2>
      <ul>
        <li><a href="/name" title="name">Name in HTML</a></li>
        <li><a href="/name.json" title="name.json">Name in JSON object</a></li>
        <li><a href="/name.json/10" title="multiple name.json">Multiple names in JSON array</a></li>
      </ul>
      <h2>Airlines</h2>
      <ul>
        <li><a href="/airline.json">Airline in JSON object</a></li>
        <li><a href="/airline.json/10">Multiple airlines in JSON array</a></li>
        <li><a href="/flightnumber.json">Flight number in JSON object</a></li>
        <li><a href="/flightnumber.json/10">Multiple flight numbers in JSON array</a></li>
      </ul>
      <h2>FFaker</h2>
      <h4>JSON interface only</h4>
      <ul>
        <li><a href="/ffaker/">Modules</a></li>
        <li><a href="/ffaker/airline">Methods</a></li>
        <li><a href="/ffaker/airline/name">Method call</a></li>
        <li><a href="/ffaker/airline/name/10">Method call with multiple results</a></li>
        <li><a href="/ffaker/airline/all">Method call for complete module results</a></li>
        <li><a href="/ffaker/airline/all/5">Method call for multiple complete module results</a></li>
      </ul>
    </nav>
  </header>
  Hostname is <%= Socket.gethostname %><br/>
  IP address is <%= Socket::getaddrinfo(Socket.gethostname,"echo",Socket::AF_INET)[0][3] %><br/>
  Uptime: <%= `uptime` %>
</body>
</html>
