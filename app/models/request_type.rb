class RequestType < ActiveRecord::Base
  has_many :payload_requests

  validates :name, presence: true
  validates :name, uniqueness: true

  def self.most_frequent
    id = joins(:payload_requests).group_by(&:id).max_by{ |k,v| v.count }[0]
    find(id)
  end

  def self.used_verbs
    pluck(:name)
  end
end
