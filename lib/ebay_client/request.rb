class EbayClient::Request
  def initialize api, name, body
    @api = api
    @name = name
    @body = body || {}
  end

  def normalized_name
    @normalized_name ||= @name.to_s.camelcase.gsub(/ebay/i, 'eBay')
  end

  def name_symbol
    @name_sym ||= @name.to_s.gsub(/_ebay_/i, 'e_bay_').to_sym
  end

  def normalized_body
    @normalized_body ||= @body.to_hash.merge body_defaults
  end

  def execute
    read_response execute_request.body
  end

  protected
  def body_defaults
    {
      :Version => @api.configuration.version,
      :WarningLevel => @api.configuration.warning_level,
      :ErrorLanguage => @api.configuration.error_language
    }
  end

  def execute_request
    @api.client.set_endpoint @api.endpoint.url_for normalized_name
    @api.client.call(name_symbol, soap_header:  @api.header.to_hash, message: normalized_body)
  end

  def read_response response_body
    EbayClient::Response.new response_body.values.first
  end
end

# We need to monkey-patch savon to be able to alter the endpoint on each call
class Savon::Client
  def set_endpoint(endpoint)
    @globals[:endpoint] = endpoint
  end
end