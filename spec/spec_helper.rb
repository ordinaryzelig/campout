ENV['RACK_ENV'] = 'test'

require_relative '../init'
require_relative '../db/connect'

require 'minitest/autorun'
# Must be required after minitest.
require 'mocha'

# VCR.
VCR.config do |c|
  c.cassette_library_dir = 'spec/support/vcr_cassettes'
  c.stub_with :fakeweb
  TWITTER_KEYS.each do |_, val|
    c.filter_sensitive_data('<FILTERED>') { val }
  end
end

# Require support files.
Dir['./spec/support/**/*.rb'].each { |f| require f }

# DatabaseCleaner.
DatabaseCleaner.strategy = :truncation

class MiniTest::Spec

  def setup
    DatabaseCleaner.clean
  end

  # E.g. given 'describe Model', return Model.
  def description
    self.class.desc
  end

end
