EbayClient
==========

Simple, lightweight eBay Trading API Client.

Installation
------------

### Rails

`Gemfile`:

    gem 'ebay_client', '~> 0.0.1'

`config/ebay_client.yml`:

    development: &sandbox
      token: '<YOUR SANDBOX AUTHENTICATION TOKEN>'
      devid: '<YOUR SANDBOX DEV ID>'
      appid: '<YOUR SANDBOX APP ID>'
      certid: '<YOUR SANDBOX CERT ID>'

    test:
      <<: *sandbox

    production:
      token: '<YOUR LIVE AUTHENTICATION TOKEN>'
      devid: '<YOUR LIVE DEV ID>'
      appid: '<YOUR LIVE APP ID>'
      certid: '<YOUR LIVE CERT ID>'

Fire up your console!

Usage
-----

### Rails

e.g. `rails console`:

    EbayClient.api.get_ebay_official_time
     => {:timestamp=>Thu, 26 Apr 2012 09:07:40 +0000, :ack=>"Success", :version=>"770", :build=>"E770_CORE_BUNDLED_14752595_R1", :@xmlns=>"urn:ebay:apis:eBLBaseComponents"} 
