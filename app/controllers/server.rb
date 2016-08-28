require 'pry'
module RushHour

  class Server < Sinatra::Base
    not_found do
      @clients = Client.all
      erb :error
    end

    get '/' do
      @clients = Client.all
      erb :dashboard
    end

    post '/sources' do
      client = ClientCreator.create(params)
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
      unless ClientCreator.client_exists?(params)
        redirect '/sources/:identifier/error'
      end

      payload = CreatePayloadRequest.create(params)

      if  CreatePayloadRequest.record_exists?(payload)
        status 403
        body "Identifier has already been taken"
      elsif payload.save
        status 200
        body "{\"identifier\":\"#{params[:identifier]}\"}"
      else
        status 400
        body "Parameters not complete"
      end
    end

    get '/sources/:identifier/data' do
      @clients = Client.all

      erb :show
    end

    get '/sources/:identifier/error' do
      unless ClientCreator.client_exists?(params)
        status 403
        body "Client does not exist"
        erb :error
      end
    end

    get '/sources' do
      @clients = Client.all

      erb :index
    end

    get '/sources/new' do
      @clients = Client.all

      erb :new
    end
  end
end
