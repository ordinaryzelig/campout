require 'spec_helper'

describe String do

  describe '#truncate' do

    it 'shortens strings with elipsis' do
      'abcdefghijklmnop'.truncate(6).must_equal 'abc...'
    end

    it 'leaves alone strings that are short enough' do
      string = 'abcdefg'
      string.truncate(string.length).must_equal string
    end

  end

end
