# Compose a message saying postal code given was not understood.
# Include instructions on acceptable postal code.

class InvalidatePostalCodeTweet < TweetString

  def initialize
    super <<-END
Sorry. I didn't understand your postal code (I'm a robot). Please send only your US postal code (5 characters max). e.g. 12345.
END
  end

end
