require 'spec_helper'

describe DenyLocationTweet do

  it 'has a valid TweetString' do
    DenyLocationTweet.new.validate!
  end

end
