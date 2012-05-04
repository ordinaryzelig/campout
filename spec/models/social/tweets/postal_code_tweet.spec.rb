require 'spec_helper'

describe PostalCodeTweet do

  describe '#valid?' do

    it 'returns true for tweet with valid location' do
      stub_geocoder(nil, nil, nil, 12345)
      '73142'.must_be_valid_postal_code_tweet
    end

    it 'returns false for tweet with invalid location' do
      stub_empty_geocoder
      'password'.wont_be_valid_postal_code_tweet
    end

  end

end
