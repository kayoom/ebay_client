class EbayClient::Endpoint
  attr_reader :configuration

  def initialize(configuration)
    @configuration = configuration
  end

  def url_for(action)
    url_base + action.to_s
  end

  def url_base
    [
      configuration.url,
      params_base
    ].join
  end

  def params_base
    "?appid=#{configuration.appid}&siteid=#{configuration.siteid}&version=#{configuration.version}&routing=#{configuration.routing}&callname="
  end
end
