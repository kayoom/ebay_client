class EbayClient::Header
  attr_reader :configuration, :namespace

  def initialize configuration, namespace
    @configuration = configuration
    @namespace = namespace
  end

  def to_hash
    {
      ns_key(:RequesterCredentials) => {
        ns_key(:eBayAuthToken) => configuration.token,
        ns_key(:Credentials) => {
          ns_key(:AppId) => configuration.appid,
          ns_key(:DevId) => configuration.devid,
          ns_key(:CertId) => configuration.certid
        }
      }
    }
  end

  protected
  def ns_key key
    "#{namespace}:#{key}"
  end
end
