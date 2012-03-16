require 'spec_helper'

describe PostalCode do

  describe '.extract_from_string' do

    it 'extracts postal_code from string' do
      PostalCode.extract_from_string('73142').must_equal '73142'
    end

    it 'extracts postal_code even with cruft' do
      PostalCode.extract_from_string('asdf 73142 fdsa').must_equal '73142'
    end

    it 'returns nil if not able to extract' do
      PostalCode.extract_from_string('asdf').must_be_nil
    end

    it 'keeps leading 0s' do
      PostalCode.extract_from_string('01234').must_equal '01234'
    end

    it 'parses canadian postal codes'

  end

end
