# encoding: utf-8
require 'bundler/setup'
Bundler.setup

require 'ebay_client'
require 'active_support/all'
require 'webmock/rspec'
require 'simplecov'
SimpleCov.start

RSpec.configure do |config|
  config.tty = true
  config.color = true
  config.formatter = :documentation # :progress, :html, :textmate

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"

  WebMock.disable_net_connect!(:allow_localhost => true)

end