# Compose a message saying postal code given was not understood.
# Include instructions on acceptable postal code.

class DenyLocationTweet < TweetString

  def initialize
    super "Sorry. I didn't understand your postal code (I'm a robot). Please send me a Direct Message with a valid US postal code. e.g. 12345."
  end

end
