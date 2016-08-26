class TargetUrl < ActiveRecord::Base
  has_many :payload_requests

  validates :name, presence: true
  validates :name, uniqueness: true

  def self.max_response_time(url)
    find_by(name: url).payload_requests.maximum(:responded_in)
  end

  def self.min_response_time(url)
    find_by(name: url).payload_requests.minimum(:responded_in)
  end

  def self.sorted_response_times(url)
    find_by(name: url).payload_requests.pluck(:responded_in).sort.reverse
  end

  def self.average_response_time(url)
    find_by(name: url).payload_requests.average(:responded_in).to_f.round(2)
  end

  def self.associated_http_verbs(url)
    request_type_ids = find_by(name: url).payload_requests.pluck(:request_type_id)
    request_type_ids.map do |request_type_id|
      RequestType.find(request_type_id).name
    end.uniq
  end

  def self.top_three_referrers(url)
    referrer_counts = find_by(name: url).payload_requests.group(:referrer_url_id).count
    top_three_rererrer_counts = referrer_counts.sort_by do |referrer, count|
      count
    end.reverse.take(3)
    top_three_rererrer_counts.map do |referrer, count|
      ReferrerUrl.find(referrer).name
    end
  end

  def self.top_three_user_agents(url)
    ua_counts = find_by(name: url).payload_requests.group(:u_agent_id).count
    top_three_rererrer_counts = ua_counts.sort_by do |ua, count|
      count
    end.reverse.take(3)
    top_three_rererrer_counts.map do |ua, count|
      [UAgent.find(ua).browser, UAgent.find(ua).os]
    end
  end

  def self.most_to_least_requested
    urls_requested = joins(:payload_requests).group(:name).count
    urls_requested.sort_by{ |k,v| v }.map(&:first).reverse
  end
end
