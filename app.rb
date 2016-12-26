require 'sinatra'
require "sinatra/reloader" if development?

require 'ffaker'

require 'json'

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
      <ul>
        <li><a href="/name" title="name">Name in HTML</a></li>
        <li><a href="/name.json" title="name.json">Name in JSON object</a></li>
        <li><a href="/name.json/10" title="multiple name.json">Multiple names in JSON array</a></li>
</ul> </nav>
  </header>
</body>
</html>
