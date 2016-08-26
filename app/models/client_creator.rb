require 'pry'
module ClientCreator
  def self.create(params)
    # binding.pry

    Client.create({
      identifier: params[:identifier],
      root_url:   params[:rootUrl]
    })
  end
end
