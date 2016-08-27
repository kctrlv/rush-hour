class PayloadParser
  def self.parse(params)
    data = JSON.parse(params[:payload])
    data = data.map { |key, value| [key.to_sym, value] }.to_h
    data[:client_identifier] = params[:identifier]
    data[:resolution_info] = parse_resolutions(data)
    data[:u_agent_info] = parse_user_agent(data)
    data
  end

  def self.create(params)
    parsed_data = parse(params)
    CreatePayloadRequest.create(parsed_data)
  end

  def self.parse_resolutions(data)
    { width:  data[:resolutionWidth],
      height: data[:resolutionHeight] }
  end

  def self.parse_user_agent(data)
    user_agent = UserAgent.parse(data[:userAgent])
    { browser: user_agent.browser,
      os:      user_agent.os }
  end
end
