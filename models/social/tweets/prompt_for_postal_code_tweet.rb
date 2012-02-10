# Compose a message prompting for postal code.

class PromptForPostalCodeTweet < TweetString

  def initialize
    super 'What is your zipcode? (I am a robot. Go to http://campout.heroku.com for more info.)'
  end

end
