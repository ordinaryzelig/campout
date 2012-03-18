require 'spec_helper'

describe TweetString do

  let(:tweet_string)         { TweetString.new('foo') }
  let(:invalid_tweet_string) { TweetString.new('f' * 141) }

  describe '#valid?' do

    it 'returns true if within character limit' do
      tweet_string.valid?.must_equal true
    end

    it 'returns false if over character limit' do
      invalid_tweet_string.valid?.must_equal false
    end

  end

  describe '#validate!' do

    it 'returns true if it is valid' do
      tweet_string.validate!.must_equal true
    end

    it 'raises LimitExceeded exception if not valid' do
      proc { invalid_tweet_string.validate!}.must_raise TweetString::LimitExceeded
    end

  end

  it '#+ returns another TweetString if added to a string' do
    new_tweet_string = tweet_string + 'bar'
    new_tweet_string.must_be_kind_of TweetString
    new_tweet_string.to_s.must_equal 'foobar'
  end

  describe '#num_chars_left' do

    it 'returns number of characters left before exceeding limit' do
      tweet_string.num_chars_left.must_equal 137
    end

    it 'returns negative number if limit already exceeded' do
      invalid_tweet_string.num_chars_left.must_equal -1
    end

  end

  it '#== compares @string' do
    a = TweetString.new('asdf')
    b = TweetString.new('asdf')
    a.must_equal b
  end

end
