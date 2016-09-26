# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'ebay_client/version'

Gem::Specification.new do |s|
  s.name        = 'ebay_client'
  s.version     = EbayClient::VERSION
  s.platform    = Gem::Platform::RUBY
  s.date        = Time.now.strftime('%Y-%m-%d')
  s.authors     = ['Marian Theisen','Burkhard Vogel-Kreykenbohm']
  s.email       = ['marian.theisen@kayoom.com','b.vogel@buddyandselly.com']
  s.summary     = 'Ebay Trading API Client'
  s.homepage    = 'http://github.com/kayoom/ebay_client'
  s.description = 'Simple, lightweight eBay Trading API Client'
  s.license     = 'MIT'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_dependency 'activesupport', '>= 3.1.0' , '< 5.0.0'
  s.add_dependency 'savon', '~> 2.0'

  s.add_development_dependency 'bundler', '~> 1.0'
  s.add_development_dependency 'rspec', '~> 3.0'
  s.add_development_dependency 'webmock', '~> 2.0'
  s.add_development_dependency 'simplecov', '~> 0.0'
end
