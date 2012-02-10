require_relative './social/tweets/tweet_string'

# require social dir.
Dir['./models/social/**/*.rb'].each { |f| require f }
