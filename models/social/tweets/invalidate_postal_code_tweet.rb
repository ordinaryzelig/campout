# Compose a message saying postal code given was not understood.
# Include instructions on acceptable postal code.

class InvalidatePostalCodeTweet < TweetString

  def initialize
    super <<-END
Sorry. I didn't understand your postal code (I'm a robot). Please send only your US, Canada, or UK postal code. E.g. 12345, V6T1Z2.
END
  end

end
