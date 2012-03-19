require 'spec_helper'

describe PromptForPostalCodeTweet do

  it 'has a valid TweetString' do
    PromptForPostalCodeTweet.new.validate!
  end

end
