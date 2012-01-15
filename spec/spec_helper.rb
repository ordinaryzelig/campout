ENV['CAMPOUT_ENV'] = 'test'

require_relative '../init.rb'

require 'minitest/autorun'

VCR.config do |c|
  c.cassette_library_dir = 'spec/support/fixtures/vcr_cassettes'
  c.stub_with :fakeweb
end
