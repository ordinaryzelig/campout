# Compose a message saying no theaters were found near a given postal_code.
# Include instructions to change postal_code.

class DenyTheatersTrackedTweet < TweetString

  def initialize(postal_code)
    super "Sorry. I couldn't find any theaters near #{postal_code}. Send me a Direct Message with another postal_code and I'll try again."
  end

end
