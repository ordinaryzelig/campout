class UnsupportedCountryTweet < TweetString

  def initialize(country_code)
    super <<-END
Sorry, but I am not yet tracking #{country_code}. Only US and Canada currently. UK is on the way. Stay tuned.
END
  end

end
