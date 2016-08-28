class Client < ActiveRecord::Base
  has_many :payload_requests
  has_many :request_types, through: :payload_request
  has_many :target_urls, through: :payload_request
  has_many :referrer_urls, through: :payload_request
  has_many :resolutions, through: :payload_request
  has_many :u_agents, through: :payload_request
  has_many :ips, through: :payload_request

  validates :identifier, presence: true
  validates :root_url,   presence: true

  validates :identifier, uniqueness: { scope: :root_url }
end
