require File.expand_path('../../lib/bigcartel', __FILE__)
require 'rubygems'
require 'rspec'
require 'webmock/rspec'


def fixture_path
  File.expand_path("../fixtures", __FILE__)
end

def fixture(file)
  File.new(fixture_path + '/' + file)
end