module RushHour

  class Server < Sinatra::Base
    not_found do
      erb :error
    end

    post '/sources' do
      client = Client.new(ClientParser.parse(params))
      if client.save
        status 200
        body "{\"identifier\":\"#{params[:identifier]}\"}"
      elsif client.errors.full_messages == ["Identifier has already been taken"]
        status 403
        body client.errors.full_messages.join(", ")
      else
        status 400
        body client.errors.full_messages.join(", ")
      end
    end

    post '/sources/:identifier/data' do
      PayloadParser.create(params)
    end

    get '/sources/:identifier/data' do
      client = Client.find_by identifier: params[:identifier]
      if client.nil?
        body "The identifier does not exist"
      elsif client.payload_requests.length == 0
        body "No data has been received for this identifier"
      else
        body "Show Statistics"
      end
    end

  end
end
