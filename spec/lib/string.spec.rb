require 'spec_helper'

describe String do

  describe '#truncate' do

    it 'shortens strings with short elipsis (2 periods)' do
      'abcdefghijklmnop'.truncate(6).must_equal 'abcd..'
    end

    it 'leaves alone strings that are short enough' do
      string = 'abcdefg'
      string.truncate(string.length).must_equal string
    end

  end

  describe '#to_theater_short_name' do

    it 'returns string removing common words and any trailing numbers to save character space' do
      name = 'fancy  schmancy theater theatre theaters  cinema cinemas    cinemark 64'
      name.to_theater_short_name.must_equal 'fancy schmancy cinemark'
    end

    it 'returns original string if altered string is blank' do
      name = 'cinema 12'
      name.to_theater_short_name.must_equal name
    end

  end

end
