class ClientParser
  def self.create(params)
    Client.create({ identifier: params[:identifier],
                    root_url:   params[:rootUrl] })
  end
end
