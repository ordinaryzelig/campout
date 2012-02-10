# Given an array of theaters, compose a message confirming theaters tracked.
# Include instructions to change.

class ConfirmTheatersTrackedTweet < TweetString

  def initialize(theaters)
    message_without_theater = TweetString.new("I'm tracking #{theaters.size} theaters including %s. If this is wrong, send me a Direct Message with the correct zipcode.")
    chars_left = message_without_theater.num_chars_left - 2 # Don't count the '%s'.
    closest_theater_name = theaters.first.short_name.truncate(chars_left)
    tweet = message_without_theater.sub('%s', closest_theater_name)
    super tweet
  end

end
