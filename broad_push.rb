require 'net/http'
require 'uri'
require 'json' 

token = 'zNVD4XFhFnK9eEMjjzDu8uKGS+u05u2EZUcN+yZPMZrEETSoZaEVnI+UNtrHmeGO5V2cMOYjcPlYJsUgDeI2osBIGZiAn5AS2AcG/0C6MKWyfGgy5JYeZMeI9bhqppHdPBM/Nhy99+ptB4RSMrQ0AQdB04t89/1O/w1cDnyilFU='
puts token
# post先のurl
uri = URI.parse('https://api.line.me/v2/bot/message/broadcast')
http = Net::HTTP.new(uri.host,uri.port)
http.use_ssl = true

# Header
headers = {
    'Authorization'=>"Bearer #{token}",
    'Content-Type' =>'application/json',
    'Accept'=>'application/json'
}

# Body
params = {"messages" => [{"type" => "text", "text" => "Hello world1"}]}

response = http.post(uri.path, params.to_json, headers)

puts response
puts response.body

