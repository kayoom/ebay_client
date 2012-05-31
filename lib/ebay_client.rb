require 'ebay_client/version'
require 'ebay_client/engine' if defined?(::Rails)

module EbayClient
  autoload :Configuration, 'ebay_client/configuration'
  autoload :Api, 'ebay_client/api'
  autoload :Endpoint, 'ebay_client/endpoint'
  autoload :Header, 'ebay_client/header'
  autoload :Request, 'ebay_client/request'
  autoload :Response, 'ebay_client/response'
end
