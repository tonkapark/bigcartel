# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "bigcartel/version"

Gem::Specification.new do |s|
  s.name        = "bigcartel"
  s.version     = BigCartel::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Matt Anderson"]
  s.email       = ["matt@tonkapark.com"]
  s.homepage    = "http://tonkapark.com"
  s.summary     = %q{Ruby wrapper for the Big Cartel API}
  s.description = %q{A Ruby wrapper for the Big Cartel External REST API}

  
  s.add_runtime_dependency('httparty', '~> 0.8.1')
  s.add_runtime_dependency('hashie', '~> 1.2.0')
  
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'webmock'
  

  s.rubyforge_project = s.name

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
