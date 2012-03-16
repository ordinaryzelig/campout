require 'spec_helper'

describe InvalidatePostalCodeTweet do

  it 'has a valid TweetString' do
    InvalidatePostalCodeTweet.new.validate!
  end

end
