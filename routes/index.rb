class Lennep < Sinatra::Base

  # Index
  # -----------------------------------------------------------

  get '/' do
    unless env['warden'].user == nil
      @sessionUser = env['warden'].user
    end
    if Faye::WebSocket.websocket?(request.env)
        ws = Faye::WebSocket.new(request.env)

        ws.on(:open) do |event|
          puts 'On Open'
        end

        ws.on(:message) do |msg|
          ws.send(msg.data.reverse)  # Reverse and reply
        end

        ws.on(:close) do |event|
          puts 'On Close'
        end

        ws.rack_response
    else
      slim :"index/index"
    end
  end
end