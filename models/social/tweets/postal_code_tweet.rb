# Response from twitter account telling us their postal code.
# Sent directly to Geocoder, so needs to be private.
# To remain private, limit characters.
# 8 characters should be enough for longest UK postal code with space.
# http://en.wikipedia.org/wiki/UK_postal_code
class PostalCodeTweet < TweetString

  def initialize(string)
    super string, character_limit: 8
  end

  def valid?
    super && postal_code.valid?
  end

  def postal_code
    @postal_code ||= PostalCode.new(self.to_s)
  end

end
