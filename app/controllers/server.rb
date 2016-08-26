module RushHour

  class Server < Sinatra::Base
    not_found do
      erb :error
    end

    post '/sources' do

    end

    post '/sources/:identifier/data' do

    end
  end

end
