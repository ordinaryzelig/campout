require 'spec_helper'

describe PostalCodeTweet do

  describe '#valid?' do

    it 'returns true for normal valid postal code' do
      '73142'.must_be_valid_postal_code_tweet
    end

    it 'returns false for invalid postal code' do
      'password'.wont_be_valid_postal_code_tweet
    end

    it 'returns false for string that is too long' do
      'ladida ladida 73142'.wont_be_valid_postal_code_tweet
    end

  end

end
