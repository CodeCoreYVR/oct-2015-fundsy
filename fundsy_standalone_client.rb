require "faraday"
require "json"

conn = Faraday.new(:url => 'http://localhost:3000') do |faraday|
  faraday.request  :url_encoded             # form-encode POST params
  faraday.response :logger                  # log requests to STDOUT
  faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
end

response = conn.get '/api/v1/campaigns'

campaigns =  JSON.parse(response.body)

campaigns.each do |campaign|
  puts campaign["title"]
end
