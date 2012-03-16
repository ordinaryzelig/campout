# Compose a message prompting for postal code.

class PromptForPostalCodeTweet < TweetString

  def initialize
    super 'What is your postal_code? (I am a robot. Go to http://campout.heroku.com for more info.)'
  end

end
