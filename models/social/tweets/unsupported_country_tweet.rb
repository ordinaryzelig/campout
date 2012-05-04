class UnsupportedCountryTweet < TweetString

  def initialize(country_code)
    super <<-END
Sorry, but I am not yet tracking #{country_code}. Only US, Canada, Great Britain, and Ireland currently.
END
  end

end
