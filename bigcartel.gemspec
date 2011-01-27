# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "bigcartel/version"

Gem::Specification.new do |s|
  s.name        = "bigcartel"
  s.version     = BigCartel::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Matt Anderson"]
  s.email       = ["matt@tonkapark.com"]
  s.homepage    = ""
  s.summary     = %q{Ruby wrapper for the Big Cartel API}
  s.description = %q{A Ruby wrapper for the Big Cartel External REST API}

  s.add_runtime_dependency('crack', '~> 0.1.8')
  s.add_runtime_dependency('httparty', '~> 0.7.3')

  s.rubyforge_project = s.name

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
