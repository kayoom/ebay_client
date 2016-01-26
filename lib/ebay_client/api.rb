require 'savon'
require 'gyoku'
require 'ebay_client/response'

class EbayClient::Api < ActiveSupport::ProxyObject
  attr_reader :configuration, :endpoint, :namespace, :header, :client, :calls

  def initialize configuration
    @configuration = configuration
    @endpoint = ::EbayClient::Endpoint.new configuration
    @namespace = :urn
    @header = ::EbayClient::Header.new configuration, namespace
    @client = ::Savon.client(
      :wsdl => configuration.wsdl_file,
      :read_timeout => configuration.http_read_timeout,
      :namespaces => {'xmlns:urn' => 'urn:ebay:apis:eBLBaseComponents' },
      :convert_request_keys_to => :camelcase,
      :log => true,
      :logger => (defined?(Rails) && Rails.respond_to?(:logger) ? Rails.logger : ::Logger.new(::STDOUT)),
      :log_level => configuration.savon_log_level,
    )
    @calls = 0

    create_methods if configuration.preload?
  end

  def dispatch name, body, fail_on_error = false
    request = ::EbayClient::Request.new self, name, body

    @calls += 1
    begin
      request.execute
    rescue ::EbayClient::Response::Exception => e
      if e.code == '218050'
        @configuration.next_key!
        request.execute
      end
      raise e
    end
  end

  def dispatch! name, body
    dispatch(name, body, true).payload!
  end

  def inspect
    "<EbayClient::Api>"
  end
  alias_method :to_s, :inspect

  protected
  def create_methods
    api_methods = ::Module.new

    client.operations.each do |action|
      name = action.to_s.gsub(/e_bay_/, '_ebay_')

      api_methods.send :define_method, name do |*args|
        dispatch name, args.first
      end

      api_methods.send :define_method, name + '!' do |*args|
        dispatch! name, args.first
      end
    end

    api_methods.send :extend_object, self
  end

  def method_missing name, *args, &block
    if name.to_s[-1,1] == '!'
      dispatch! name[0..-2], args.first
    else
      dispatch name, args.first
    end
  end
end
