class CreatePayloadRequest
  def self.create(params)
    data = PayloadParser.parse(params)
    parse(data)
  end

  def self.parse(data)
    PayloadRequest.new({
      client_id:    Client.find_by( identifier: data[:client_identifier] ).id,
      request_type: RequestType.find_or_create_by( name: data[:requestType] ),
      target_url:   TargetUrl.find_or_create_by( name: data[:url] ),
      referrer_url: ReferrerUrl.find_or_create_by( name: data[:referredBy] ),
      resolution:   Resolution.find_or_create_by( data[:resolution_info] ),
      u_agent:      UAgent.find_or_create_by( data[:u_agent_info] ),
      ip:           Ip.find_or_create_by( address: data[:ip] ),
      responded_in: data[:respondedIn],
      requested_at: data[:requestedAt]
    })
  end

  def self.record_exists?(payload)
    match = PayloadRequest.where(
      client_id: payload.client_id,
      request_type_id: payload.request_type_id,
      target_url_id: payload.target_url_id,
      referrer_url_id: payload.referrer_url_id,
      resolution_id: payload.resolution_id,
      u_agent_id: payload.u_agent_id,
      ip_id: payload.ip_id,
      responded_in: payload.responded_in,
      requested_at: payload.requested_at
    )
    !match.empty?
  end
end
