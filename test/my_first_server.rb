require 'webrick'

server = WEBrick::HTTPServer.new(:Port => 8080)

server.mount_proc '/' do |request, response|
  response['Content_Type'] = 'text/text'
  response.body = request.path
end

trap 'INT' do
  server.shutdown
end

server.start