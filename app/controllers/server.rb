require 'pry'
module RushHour

  class Server < Sinatra::Base
    not_found do
      erb :error
    end

    get '/' do
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

    post '/sources/form' do
      client = ClientCreator.create(params)
      if client.save
        redirect '/sources'
      else
        redirect "/sources/new?error=#{client.errors.full_messages.join(", ")}"
      end
    end

    post '/sources/:identifier/data' do
      unless ClientCreator.client_exists?(params)
        redirect "/sources/#{params[:identifier]}/error"
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
      erb :show
    end

    get '/sources/:identifier/error' do
      unless ClientCreator.client_exists?(params)
        status 403
        body "Client does not exist"
      end
    end

    get '/sources' do
      @clients = Client.all

      erb :index
    end

    get '/sources/new' do
      @error = params[:error]
      erb :new
    end

    get '/sources/login' do
      @error = params[:error]
      erb :login
    end

    post '/sources/login' do
      redirect '/'
    end
  end
end
