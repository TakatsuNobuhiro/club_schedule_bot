require 'net/http'
require 'uri'
require 'json' 

token = ENV["LINE_CHANNEL_TOKEN"]
# post先のurl
uri = URI.parse('https://api.line.me/v2/bot/message/broadcast')
http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true
http.verify_mode = OpenSSL::SSL::VERIFY_NONE

req = Net::HTTP::Post.new(uri.request_uri)
# Header
req["Authorization"] = "Bearer #{token}"
req["Content-Type"] = "application/json"
# Body
post_data = {"message" => {"type" => "text", "text" => "Hello world1"}}.to_json
req.body = post_data

res = http.request(req)
# ログ
puts res.code, res.msg, res.body

