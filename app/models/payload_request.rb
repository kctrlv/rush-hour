class PayloadRequest < ActiveRecord::Base
  belongs_to :client
  belongs_to :request_type
  belongs_to :target_url
  belongs_to :referrer_url
  belongs_to :resolution
  belongs_to :u_agent
  belongs_to :ip

  validates :client_id,         presence: true
  validates :request_type_id,   presence: true
  validates :target_url_id,     presence: true
  validates :referrer_url_id,   presence: true
  validates :resolution_id,     presence: true
  validates :u_agent_id,        presence: true
  validates :ip_id,             presence: true
  validates :responded_in,      presence: true
  validates :requested_at,      presence: true
end
