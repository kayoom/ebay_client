#require 'rspec'
require 'spec_helper'

describe EbayClient::Api do

  context 'without preload' do
    before(:each) do
      configuration = EbayClient::Configuration.load(File.expand_path('../../config/without_preload.yml', __FILE__))
      configuration = configuration['test']
      @api = EbayClient::Api.new configuration
      @url = "https://api.sandbox.ebay.com/wsapi?appid=#{configuration.appid}&callname=GeteBayOfficialTime&routing=#{configuration.routing}&siteid=#{configuration.siteid}&version=#{configuration.version}"
    end

    it 'should respond to inspect' do
      expect(@api.inspect).to eq('<EbayClient::Api>')
    end

    it 'should successful dispatch a call' do
      stub_request(:post, @url).
        to_return(:status => 200, :body => success_response)
      result = @api.get_ebay_official_time
      expect(result.warning?).to be false
      expect(result.success?).to be true
      expect(result.payload[:timestamp]).to eq(DateTime.new(2009,10,11,12,13,14))
    end

    it 'should successful dispatch a banged call' do
      stub_request(:post, @url).
          to_return(:status => 200, :body => success_response)
      result = @api.get_ebay_official_time!
      expect(result[:timestamp]).to eq(DateTime.new(2009,10,11,12,13,14))
    end
  end

  context 'with preload' do
    before(:each) do
      configuration = EbayClient::Configuration.load(File.expand_path('../../config/with_preload.yml', __FILE__))
      configuration = configuration['test']
      @api = EbayClient::Api.new configuration
      @url = "https://api.sandbox.ebay.com/wsapi?appid=#{configuration.appid}&callname=GeteBayOfficialTime&routing=#{configuration.routing}&siteid=#{configuration.siteid}&version=#{configuration.version}"
    end

    it 'should successful dispatch a call' do
      stub_request(:post, @url).
          to_return(:status => 200, :body => success_response)
      result = @api.get_ebay_official_time
      expect(result.success?).to be true
      expect(result.payload[:timestamp]).to eq(DateTime.new(2009,10,11,12,13,14))
    end

    it 'should successful dispatch a banged call' do
      stub_request(:post, @url).
          to_return(:status => 200, :body => success_response)
      result = @api.get_ebay_official_time!
      expect(result[:timestamp]).to eq(DateTime.new(2009,10,11,12,13,14))
    end

    it 'should dispatch a call with api key change' do
      stub_request(:post, @url).
          to_return({:status => 200, :body => recoverable_failure_response}, {:status => 200, :body => success_response})
      expect(@api.dispatch!(:get_ebay_official_time, nil)[:timestamp]).to eq(DateTime.new(2009,10,11,12,13,14))
    end

    it 'should dispatch a failed call' do
      stub_request(:post, @url).
          to_return({:status => 200, :body => failure_response})
      expect{@api.dispatch!(:get_ebay_official_time, nil)}.to raise_exception EbayClient::Response::Exception
    end
  end

  context 'with erb' do
    before(:each) do
      configuration = EbayClient::Configuration.load(File.expand_path('../../config/with_erb.yml', __FILE__))
      configuration = configuration['test']
      @api = EbayClient::Api.new configuration
      @url = "https://api.sandbox.ebay.com/wsapi?appid=#{configuration.appid}&callname=GeteBayOfficialTime&routing=#{configuration.routing}&siteid=#{configuration.siteid}&version=#{configuration.version}"
    end

    it 'should load the erb-based configuration values' do
      expect(@api.configuration.api_keys.first.token).to eq('token')
      expect(@api.configuration.api_keys.first.devid).to eq('devid')
      expect(@api.configuration.api_keys.first.appid).to eq('appid')
      expect(@api.configuration.api_keys.first.certid).to eq('certid')
    end
  end

  def success_response
    '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'+
      '<soapenv:Body><GeteBayOfficialTimeResponse xmlns="urn:ebay:apis:eBLBaseComponents"><Timestamp>2009-10-11T12:13:14.000Z</Timestamp><Ack>Success</Ack>' +
      "<Version>#{@api.configuration.version}</Version><Build>E#{@api.configuration.version}_CORE_API_17785418_R1</Build></GeteBayOfficialTimeResponse></soapenv:Body></soapenv:Envelope>"
  end
  def failure_response
    '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'+
      '<soapenv:Body><GeteBayOfficialTimeResponse xmlns="urn:ebay:apis:eBLBaseComponents"><Ack>Failure</Ack><Errors><ShortMessage>Internal error to the application.</ShortMessage>' +
      '<LongMessage>Internal error to the application.</LongMessage><ErrorCode>10007</ErrorCode><SeverityCode>Error</SeverityCode><ErrorParameters ParamID="0"><Value>12345678</Value></ErrorParameters></Errors>' +
      "<Version>#{@api.configuration.version}</Version><Build>E#{@api.configuration.version}_CORE_API_17785418_R1</Build></GeteBayOfficialTimeResponse></soapenv:Body></soapenv:Envelope>"
  end
  def recoverable_failure_response
    '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'+
      '<soapenv:Body><GeteBayOfficialTimeResponse xmlns="urn:ebay:apis:eBLBaseComponents"><Ack>Failure</Ack><Errors><ShortMessage>User limit exceeded.</ShortMessage>' +
      '<LongMessage>Users of this application are limited to a number of calls they can make on a daily, hourly and 6-minute basis. You have gone over the daily limit. Please try again after 24 hours.</LongMessage><ErrorCode>218050</ErrorCode><SeverityCode>Error</SeverityCode></Errors>' +
      "<Version>#{@api.configuration.version}</Version><Build>E#{@api.configuration.version}_CORE_API_17785418_R1</Build></GeteBayOfficialTimeResponse></soapenv:Body></soapenv:Envelope>"
  end
end
