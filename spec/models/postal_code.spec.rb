require 'spec_helper'

describe PostalCode do

  describe '#valid?' do

    it 'returns true for a US zipcode' do
      '73142'.must_be_valid_postal_code
    end

    it 'returns true for a Canadian postal code' do
      'k1a 0b1'.must_be_valid_postal_code
    end

    it 'returns true for a UK postal code' do
      'M1 1AA'.must_be_valid_postal_code
    end

    it 'returns false for string with no numbers' do
      'password'.wont_be_valid_postal_code
    end

  end

end
