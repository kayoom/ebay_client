# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "ebay_client/version"

Gem::Specification.new do |s|
  s.name        = "ebay_client"
  s.version     = EbayClient::VERSION
  s.platform    = Gem::Platform::RUBY
  s.date        = Time.now.strftime("%Y-%m-%d")
  s.authors     = ["Marian Theisen"]
  s.email       = 'marian.theisen@kayoom.com'
  s.summary     = "Ebay Trading API Client"
  s.homepage    = "http://github.com/kayoom/ebay_client"
  s.description = "Simple, lightweight eBay Trading API Client"
  s.license     = "MIT"
  s.metadata    = {
    'issue_tracker' => 'https://github.com/kayoom/ebay_client/issues'
  }

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "activesupport", ">= 3.1.0"
  s.add_dependency "savon", "< 2.0.0"

  s.add_development_dependency "bundler"
end
