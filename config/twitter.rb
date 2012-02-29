require 'twitter'

# Organize keys into hash for VCR filtering convenience.
TWITTER_KEYS = {
  consumer_key:       ENV['TWITTER_CONSUMER_KEY'],
  consumer_secret:    ENV['TWITTER_CONSUMER_SECRET'],
  oauth_token:        ENV['TWITTER_OAUTH_TOKEN'],
  oauth_token_secret: ENV['TWITTER_OAUTH_TOKEN_SECRET'],
}

Twitter.configure do |config|
  TWITTER_KEYS.each do |key, val|
    config.send("#{key}=", val)
  end
end
