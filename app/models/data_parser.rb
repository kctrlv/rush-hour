class DataParser
  def self.create(params)
    data = JSON.parse(params[:payload])
    data = data.map { |k, v| [k.to_sym, v] }.to_h
    data[:resolution_info] = parse_resolutions(data)
    data[:u_agent_info] = parse_user_agent(data)
    PayloadRequest.create(
      client_id:    Client.find_by( identifier: params[:identifier] ).id,
      request_type: RequestType.find_or_create_by( name: data[:requestType] ),
      target_url:   TargetUrl.find_or_create_by( name: data[:url] ),
      referrer_url: ReferrerUrl.find_or_create_by( name: data[:referredBy] ),
      resolution:   Resolution.find_or_create_by( data[:resolution_info] ),
      u_agent:      UAgent.find_or_create_by( data[:u_agent_info] ),
      ip:           Ip.find_or_create_by( address: data[:ip] ),
      responded_in: data[:respondedIn],
      requested_at: data[:requestedAt])
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
