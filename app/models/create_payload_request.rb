class CreatePayloadRequest

  def self.create(data)

    PayloadRequest.create(
      client_id:    Client.find_by( identifier: data[:client_identifier] ).id,
      request_type: RequestType.find_or_create_by( name: data[:requestType] ),
      target_url:   TargetUrl.find_or_create_by( name: data[:url] ),
      referrer_url: ReferrerUrl.find_or_create_by( name: data[:referredBy] ),
      resolution:   Resolution.find_or_create_by( data[:resolution_info] ),
      u_agent:      UAgent.find_or_create_by( data[:u_agent_info] ),
      ip:           Ip.find_or_create_by( address: data[:ip] ),
      responded_in: data[:respondedIn],
      requested_at: data[:requestedAt]
    )
  end
end
