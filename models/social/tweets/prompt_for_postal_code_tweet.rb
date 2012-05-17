# Compose a message prompting for postal code.

class PromptForPostalCodeTweet < TweetString

  def initialize
    super <<-END
What is your postal_code? (I am a robot. I only understand US, Canada, and UK postal codes. Go to http://campout.heroku.com for more info.)
END
  end

end
