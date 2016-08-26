module RushHour

  class Server < Sinatra::Base
    not_found do
      erb :error
    end

    post '/sources' do
      if repeat_request?(params)
        status 403
        body "403 Forbidden"
      elsif valid_request?(params)
        DataParser.create(params)
        status 200
        body "{\"identifier\":\"#{params[:identifier]}\"}"
      else
        status 400
        body "400 Bad Request"
      end

    end

    def valid_request?(params)
      !params[:identifier].nil? && !params[:rootUrl].nil?
    end

    def repeat_request?(params)
      !Client.find_by( identifier: params[:identifier] ).nil? &&
      !Client.find_by( root_url: params[:rootUrl] ).nil?
    end
  end

end
