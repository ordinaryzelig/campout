require 'spec_helper'

describe UnsupportedCountryTweet do

  it 'has a valid TweetString' do
    UnsupportedCountryTweet.new('UK').validate!
  end

end
