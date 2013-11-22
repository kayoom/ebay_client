EbayClient
==========

Simple, lightweight eBay Trading API Client.

Installation
------------

### Rails

`Gemfile`:

    gem 'ebay_client', '~> 0.1.0'

`config/ebay_client.yml`:

    development: &sandbox
      api_keys:
        - token: '<YOUR SANDBOX AUTHENTICATION TOKEN>'
          devid: '<YOUR SANDBOX DEV ID>'
          appid: '<YOUR SANDBOX APP ID>'
          certid: '<YOUR SANDBOX CERT ID>'

    test:
      <<: *sandbox

    production:
      api_keys:
        - token: '<YOUR LIVE AUTHENTICATION TOKEN>'
          devid: '<YOUR LIVE DEV ID>'
          appid: '<YOUR LIVE APP ID>'
          certid: '<YOUR LIVE CERT ID>'

Fire up your console!

Usage
-----

### Rails

e.g. `rails console`:

    EbayClient.api.get_ebay_official_time!
    # => {:timestamp=>Fri, 22 Nov 2013 12:31:02 +0000}

Notes
-----
* An overview of possible API calls can be found at the
  [eBay Trading API docs](http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/)
* Names (Methods, Types, Members) are mapped from `CamelCase` \<=\> `snake_case`
* `eBay` is mapped to `ebay`, i.e. `GeteBayOfficialTime` \<=\>
  `get_ebay_official_time`
* For each call, there are 2 methods, with and without a bang (`!`), i.e.  
    * `get_ebay_official_time` returns an `EbayClient::Response`
      instance, which contains the `ack` value, the `payload` and possibly
      `errors`
    * `get_ebay_official_time!` returns the payload as a `Hash` and raises
      an `EbayClient::Response::Exception` if the API returned an error.
* You can specify an arbitrary amount of API key/tokens in your
  `ebay_client.yml`. On initialization, the EbayClient will randomly
  choose one of them. If you run out of API calls, it will automatically
  switch to another key.
* Pull requests and bug reports are welcome!
