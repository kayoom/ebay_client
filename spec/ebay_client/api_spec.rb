#require 'rspec'
require 'spec_helper'

describe EbayClient::Api do

  before(:each) do
    @configuration = EbayClient::Configuration.load(File.expand_path('../../../config/defaults.yml', __FILE__))
    @configuration['test'].api_keys = [EbayClient::Configuration::ApiKey.new({token: 'token', devid: 'devid', appid: 'appid', certid: 'certid'})]
    @configuration['test'].current_key = EbayClient::Configuration::ApiKey.new({token: 'token', devid: 'devid', appid: 'appid', certid: 'certid'})
    @api = EbayClient::Api.new @configuration['test']
  end

  it 'should successful dispatch a call' do
    stub_request(:post, "https://api.sandbox.ebay.com/wsapi?appid=#{@configuration['test'].appid}&callname=GeteBayOfficialTime&routing=default&siteid=0&version=#{@configuration['test'].version}").
      to_return(:status => 200, :body => success_response)
    expect(@api.dispatch!(:get_ebay_official_time, nil)[:timestamp]).to eq(DateTime.new(2009,10,11,12,13,14))
  end

  it 'should dispatch a call with api key change' do
    stub_request(:post, "https://api.sandbox.ebay.com/wsapi?appid=#{@configuration['test'].appid}&callname=GeteBayOfficialTime&routing=default&siteid=0&version=#{@configuration['test'].version}").
        to_return({:status => 200, :body => recoverable_failure_response}, {:status => 200, :body => success_response})
    expect(@api.dispatch!(:get_ebay_official_time, nil)[:timestamp]).to eq(DateTime.new(2009,10,11,12,13,14))
  end

  it 'should dispatch a failed call' do
    stub_request(:post, "https://api.sandbox.ebay.com/wsapi?appid=#{@configuration['test'].appid}&callname=GeteBayOfficialTime&routing=default&siteid=0&version=#{@configuration['test'].version}").
        to_return(:status => 200, :body => failure_response)
    expect{@api.dispatch!(:get_ebay_official_time, nil)}.to raise_exception '        Short Msg - 931

               Long Msg'
  end

  def success_response
    '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'+
    '<soapenv:Body><GeteBayOfficialTimeResponse xmlns="urn:ebay:apis:eBLBaseComponents"><Timestamp>2009-10-11T12:13:14.000Z</Timestamp><Ack>Success</Ack>' +
    '<Version>949</Version><Build>E949_CORE_API_17785418_R1</Build></GeteBayOfficialTimeResponse></soapenv:Body></soapenv:Envelope>'
  end
  def failure_response
    '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'+
        '<soapenv:Body><GeteBayOfficialTimeResponse xmlns="urn:ebay:apis:eBLBaseComponents"><Ack>Failure</Ack><Errors><ShortMessage>Short Msg</ShortMessage>' +
        '<LongMessage>Long Msg</LongMessage><ErrorCode>931</ErrorCode><SeverityCode>Error</SeverityCode></Errors><Version>949</Version>' +
        '<Build>E949_CORE_API_17785418_R1</Build></GeteBayOfficialTimeResponse></soapenv:Body></soapenv:Envelope>'
  end
  def recoverable_failure_response
    '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'+
        '<soapenv:Body><GeteBayOfficialTimeResponse xmlns="urn:ebay:apis:eBLBaseComponents"><Ack>Failure</Ack><Errors><ShortMessage>Short Msg</ShortMessage>' +
        '<LongMessage>Long Msg</LongMessage><ErrorCode>218050</ErrorCode><SeverityCode>Error</SeverityCode></Errors><Version>949</Version>' +
        '<Build>E949_CORE_API_17785418_R1</Build></GeteBayOfficialTimeResponse></soapenv:Body></soapenv:Envelope>'
  end
end