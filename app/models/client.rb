class Client < ActiveRecord::Base
  has_many :payload_requests
  has_many :request_types, through: :payload_requests
  has_many :target_urls, through: :payload_requests
  has_many :referrer_urls, through: :payload_requests
  has_many :resolutions, through: :payload_requests
  has_many :u_agents, through: :payload_requests
  has_many :ips, through: :payload_requests

  validates :identifier, presence: true
  validates :root_url,   presence: true

  validates :identifier, uniqueness: { scope: :root_url }

  def average_response_time
    payload_requests.average_response_time
  end

  def min_response_time
    payload_requests.min_response_time
  end

  def max_response_time
    payload_requests.max_response_time
  end

  def most_frequent_request_type
    request_types.most_frequent.name
  end

  def all_http_verbs_used
    request_types.used_verbs.uniq
  end

  def most_to_least_requested_urls
    target_urls.most_to_least_requested
  end

  def browser_breakdown
    u_agents.group(:browser).count
  end

  def os_breakdown
    u_agents.group(:os).count
  end

  def resolution_breakdown
    res = resolutions.group(:width, :height).count
    res.keys.each do |key|
      res["#{key[0]}x#{key[1]}"] = res.delete key
    end
    res
  end

end
