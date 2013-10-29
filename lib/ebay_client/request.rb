class EbayClient::Request
  def initialize api, name, body
    @api = api
    @name = name
    @body = body || {}
  end

  def normalized_name
    @normalized_name ||= @name.to_s.camelcase.gsub(/ebay/i, 'eBay')
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
    @api.client.request(@api.namespace, normalized_name + 'Request') do |soap|
      soap.endpoint = @api.endpoint.url_for normalized_name
      soap.header = @api.header.to_hash
      soap.body = normalized_body
    end
  end

  def read_response response_body
    EbayClient::Response.new response_body.values.first
  end
end
