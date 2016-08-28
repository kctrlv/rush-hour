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

    post '/new/form' do
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
      @client = Client.find_by( identifier: params[:identifier] )
      redirect "/sources/#{params[:identifier]}/error" if @client.nil?

      erb :client_stats
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

    get '/sources/:identifier' do
      @client = Client.find_by( identifier: params[:identifier] )
      redirect "/sources/#{params[:identifier]}/error" if @client.nil?

      erb :show
    end

    get '/new/client' do
      @error = params[:error]
      erb :new
    end

    get '/login/client' do
      @error = params[:error]
      erb :login
    end

    post '/login/client' do
      redirect '/'
    end

    get '/sources/:identifier/url/:relativepath' do
      @client = Client.find_by( identifier: params[:identifier] )
      redirect "/sources/#{params[:identifier]}/error" if @client.nil?
      @relativepath = @client.target_urls.find_by( name: "#{@client.root_url}/#{params[:relativepath]}")
      redirect "/sources/#{params[:identifier]}/error" if @relativepath.nil?

      erb :url_stats
    end

    get '/sources/:identifier/url' do
      @client = Client.find_by( identifier: params[:identifier] )
      redirect "/sources/#{params[:identifier]}/error" if @client.nil?
      @relativepaths = @client.target_urls.all.uniq

      erb :url
    end
  end
end
