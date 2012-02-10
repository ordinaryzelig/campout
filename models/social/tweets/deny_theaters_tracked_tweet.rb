# Compose a message saying no theaters were found near a given zipcode.
# Include instructions to change zipcode.

class DenyTheatersTrackedTweet < TweetString

  def initialize(zipcode)
    super "Sorry. I couldn't find any theaters near #{zipcode}. Send me a Direct Message with another zipcode and I'll try again."
  end

end
