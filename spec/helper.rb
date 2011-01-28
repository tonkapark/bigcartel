$:.unshift(File.expand_path('../../lib', __FILE__))

require 'rubygems'
require 'bundler'

Bundler.require(:default, :development)

require 'bigcartel'

Rspec.configure do |config|

  config.before(:each) do

  end
end