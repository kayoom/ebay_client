require 'savon'

class EbayClient::Api < ActiveSupport::BasicObject
  attr_reader :configuration, :endpoint, :namespace, :header, :client

  def initialize configuration
    @configuration = configuration
    @endpoint = ::EbayClient::Endpoint.new configuration
    @namespace = :urn
    @header = ::EbayClient::Header.new configuration, namespace
    @client = ::Savon::Client.new configuration.wsdl_file
  end

  def dispatch name, body
    name = camelize name
    response = client.request namespace, name do |soap|
      soap.endpoint = endpoint.url_for name
      soap.header = header.to_hash
      soap.body = normalize body
    end

    response.body.values.first
  end

  def inspect
    "<EbayClient::Api>"
  end
  alias_method :to_s, :inspect

  protected
  def camelize name
    name = name.to_s.camelcase

    name.gsub /ebay/i, 'eBay'
  end

  def normalize body
    body ||= {}
    body.to_hash.merge :Version => configuration.version
  end

  def method_missing name, *args, &block
    dispatch name, args.first
  end
end
