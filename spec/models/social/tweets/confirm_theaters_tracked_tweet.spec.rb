require 'spec_helper'

describe ConfirmTheatersTrackedTweet do

  it '.new composes message confirming theaters tracked' do
    theaters = [Theater.new(name: 'amc')]
    tweet = ConfirmTheatersTrackedTweet.new(theaters)
    tweet.to_s.must_equal "I'm tracking 1 theaters including amc. If this is wrong, send me a Direct Message with the correct postal_code."
  end

end
