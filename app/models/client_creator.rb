class ClientCreator
  def self.parse(params)
    { identifier: params[:identifier],
      root_url:   params[:rootUrl] }
  end

  def self.create(params)
    parsed_data = parse(params)
    Client.new(parsed_data)
  end

  def self.client_exists?(params)
    Client.find_by( identifier: params[:identifier] )
  end
end
