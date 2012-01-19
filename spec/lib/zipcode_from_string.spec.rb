require 'spec_helper'

describe Zipcode do

  describe '.extract_from_string' do

    it 'extracts zipcode from string' do
      Zipcode.extract_from_string('73142').must_equal 73142
    end

    it 'extracts zipcode even with cruft' do
      Zipcode.extract_from_string('asdf 73142 fdsa').must_equal 73142
    end

    it 'returns nil if not able to extract' do
      Zipcode.extract_from_string('asdf').must_be_nil
    end

  end

end
